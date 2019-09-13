# frozen_string_literal: true

require "dynamoid"

class Shrine
  module Plugins
    module Dynamoid
      def self.load_dependencies(uploader, *)
        uploader.plugin :model
        uploader.plugin :_persistence, plugin: self
      end

      def self.configure(uploader, **opts)
        uploader.opts[:dynamoid] ||= { validations: true, callbacks: true }
        uploader.opts[:dynamoid].merge!(opts)
      end

      module AttachmentMethods
        def included(model)
          super

          return unless model < ::Dynamoid::Document

          name = @name

          if shrine_class.opts[:dynamoid][:validations]
            # add validation plugin integration
            model.validate do
              next unless send(:"#{name}_attacher").respond_to?(:errors)

              send(:"#{name}_attacher").errors.each do |message|
                errors.add(name, message)
              end
            end
          end

          if shrine_class.opts[:dynamoid][:callbacks]
            model.before_save do
              if send(:"#{name}_attacher").changed?
                send(:"#{name}_attacher").save
              end
            end

            model.after_save do
              if send(:"#{name}_attacher").changed?
                send(:"#{name}_attacher").finalize
                send(:"#{name}_attacher").persist
              end
            end

            model.after_destroy do
              send(:"#{name}_attacher").destroy_attached
            end
          end

          define_method :reload do |*args|
            result = super(*args)
            instance_variable_set(:"@#{name}_attacher", nil)
            result
          end
        end
      end

      # The _persistence plugin uses #dynamoid_persist, #dynamoid_reload and
      # #dynamoid? to implement the following methods:
      #
      #   * Attacher#persist
      #   * Attacher#atomic_persist
      #   * Attacher#atomic_promote
      module AttacherMethods
        private

        # Saves changes to the model instance, raising exception on validation
        # errors. Used by the _persistence plugin.
        def dynamoid_persist
          record.save(validate: false)
        end

        # Yields the reloaded record. Used by the _persistence plugin.
        def dynamoid_reload
          record_copy    = record.dup
          record_copy.id = record.id

          yield record_copy.reload
        end

        # Returns true if the data attribute represents a :raw field.
        # However this is not certain as :raw fields can store different types
        # of data. Used by the _persistence plugin to determine whether
        # serialization should be skipped.
        def dynamoid_hash_attribute?
          field = record.class.attributes[attribute]
          field && field[:type] == :raw
        end

        # Returns whether the record is a Dynamoid document. Used by the
        # _persistence plugin.
        def dynamoid?
          record.is_a?(::Dynamoid::Document)
        end
      end
    end

    register_plugin(:dynamoid, Dynamoid)
  end
end
