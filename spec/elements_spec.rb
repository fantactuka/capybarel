require "spec_helper"

describe Capybarel::DSL::Elements do
  before do
    @map = {found_item: ".find-item", visible_item: ".visible-item", dynamic_item: ".dynamic-item", within_item: ".within-item", within_box: ".within-test", missed_item: ".missed-item"}
    elements_map.set @map
  end

  describe "#elements map" do
    it "should store map" do
      elements_map.should == @map
    end

    it "should reset map" do
      elements_map.clear
      elements_map.should == {}
    end

    it "should append elements map" do
      elements_map << {header: ".header"}
      elements_map.should == @map.merge(header: ".header")
    end

    it "should validate elements map" do
      lambda { elements_map.set [] }.should raise_error(TypeError)
    end
  end

  describe "#element" do
    before do
      visit_local path("support/index.html")
    end

    it "should raise error if wrong element name provided" do
      -> { element(:invalid_element_key) }.should raise_error(Capybarel::ElementMapNotFoundError)
    end

    describe "one" do
      it "should find element" do
        element(:found_item).should be_a(Capybara::Node::Element)
      end

      it "should find first element by default" do
        element(:found_item).text.should == "find-item-0"
      end

      it "should find indexed element" do
        element(:found_item, index: 2).text.should == "find-item-2"
      end
    end

    describe "all" do
      it "should find all elements" do
        element(:found_item, all: true).map(&:text).should == %w(find-item-0 find-item-1 find-item-2)
      end

      it "should use elements as alias" do
        elements(:found_item).map(&:text).should == %w(find-item-0 find-item-1 find-item-2)
      end

      it "should wait for dynamic elements" do
        elements(:dynamic_item).map(&:text).should == %w(dynamic-item-0 dynamic-item-1)
      end

      it "should find only visible elements by default" do
        elements(:visible_item).map(&:text).should == %w(visible-item-0 visible-item-1 visible-item-2)
      end

      it "should fail if not elements found by default" do
        -> { elements(:missed_item) }.should raise_error(Capybara::ElementNotFound)
      end

      it "should not fail with greedy: false passed" do
        elements(:missed_item, greedy: false).should == []
      end
    end

    describe "within" do
      it "should find element for css" do
        elements(:within_item, within: ".within-test").map(&:text).should == %w(within-item-0 within-item-1 within-item-2)
      end

      it "should find element for element" do
        elements(:within_item, within: element(:within_box)).map(&:text).should == %w(within-item-0 within-item-1 within-item-2)
      end

      it "should find element for selector name" do
        elements(:within_item, within: :within_box).map(&:text).should == %w(within-item-0 within-item-1 within-item-2)
      end
    end
  end

  describe "#element?" do
    it "should return false for missed element" do
      element?(:missed_item).should be_false
      elements?(:missed_item).should be_false
    end

    it "should return true for found element" do
      element?(:found_item).should be_true
      elements?(:found_item).should be_true
    end
  end
end
