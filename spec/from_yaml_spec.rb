require "spec_helper"

describe Capybarel::DSL::FromYaml do
  describe "#from_yaml" do
    before do
      Capybarel.configure do |c|
        c.yaml_config_file = path("support/config.yml")
      end
    end

    it "should get value from yaml" do
      from_yaml("dev").should be_a Hash
    end

    it "should get nested value" do
      from_yaml("dev.expansion.url").should == "http://google.com"
    end

    it "should raise error for invalid key" do
      -> { from_yaml("dev.expansion.bla") }.should raise_error
    end
  end
end
