module Capybarel
  module DSL
    module FromYaml

      def from_yaml(keys)
        keys.split(".").inject(yaml_config_cache) do |memo, key|
          raise "#{yaml_config_file} does not have `#{name}` key" unless memo.has_key?(key)
          memo[key]
        end
      end

      private
      def yaml_config_file
        Capybarel::Config.yaml_config_file
      end

      def yaml_config_cache
        @from_yaml_cache ||= (
          raise "Yaml config file #{yaml_config_file} does not exist" unless File.exists?(yaml_config_file)
          content = File.read(yaml_config_file)
          YAML.load(content)
        )
      end

    end
  end
end