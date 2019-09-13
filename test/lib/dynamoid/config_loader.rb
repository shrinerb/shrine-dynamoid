# frozen_string_literal: true

module Dynamoid
  module ConfigLoader
    class << self
      def load!(path, environment)
        template = ERB.new(File.new(path).read)
        yaml = YAML.load(template.result).deep_symbolize_keys
        ddb_config = yaml[environment]

        ::Dynamoid.configure do |config|
          config.reset

          config.logger = nil
          config.namespace = "shrine_development"
          config.endpoint = ddb_config[:host]
        end
      end
    end
  end
end
