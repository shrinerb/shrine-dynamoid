# frozen_string_literal: true

module Dynamoid
  module Reset
    class << self
      def all
        Dynamoid.adapter.list_tables.each do |table|
          # Only delete tables in our namespace
          if table =~ /^#{Dynamoid::Config.namespace}/
            Dynamoid.adapter.delete_table(table)
          end
        end

        Dynamoid.adapter.tables.clear
        # Recreate all tables to avoid unexpected errors
        Dynamoid.included_models.each { |m| m.create_table(sync: true) }
      end
    end
  end
end
