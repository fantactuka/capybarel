module Capybarel
  module RSpecHelpers
    def path(*args)
      File.join File.dirname(__FILE__), "../", *args
    end
  end
end
