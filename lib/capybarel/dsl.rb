require "capybarel/dsl/elements"
require "capybarel/dsl/javascript"
require "capybarel/dsl/from_yaml"

module Capybarel
  module DSL
    module All
      include Capybarel::DSL::Elements
      include Capybarel::DSL::JavaScript
      include Capybarel::DSL::FromYaml
    end
  end
end
