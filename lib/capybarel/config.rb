module Capybarel
  module Config
    extend self

    attr_accessor :yaml_config_file
    @yaml_config_file = nil
  end

  def self.configure
    yield(Config)
  end
end
