module Capybara
  class Session
    def visit_local(path)
      driver.visit_local(path)
    end
  end

  module Selenium
    class Driver
      def visit_local(path)
        browser.navigate.to("file://#{path}")
      end
    end
  end

  module Extension
    def visit_local(path)
      page.visit_local(path)
    end
  end
end
