$: << File.join(File.dirname(__FILE__), "../")

require "lib/capybarel"
require "rspec"
require "capybara"
require "capybara/dsl"
require "capybara/rspec/matchers"
require "selenium-webdriver"

Dir[File.join File.dirname(__FILE__), "support/**/*.rb"].each { |f| require f }

RSpec.configure do |r|
  r.include Capybara::DSL
  r.include Capybara::RSpecMatchers
  r.include Capybara::Extension
  r.include Capybarel::RSpecHelpers

  r.after :suite do
    Dir[File.join File.dirname(__FILE__), "../**/chromedriver.log"].each { |f| FileUtils.rm_rf(f) }
  end
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.run_server = false
Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome
Capybara.default_wait_time = 5
