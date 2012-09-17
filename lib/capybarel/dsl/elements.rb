module Capybarel
  module DSL
    module Elements
      include Capybara::DSL

      ##
      #
      # Locate single or multiple element depending on passed params
      # using elements_map selector
      #
      #     self.elements_map = { page: ".page", header: ".header", logo: ".logo a", nav_item: "ul.nav li" }
      #
      #     element :page                             => Capybara::Node::Element
      #     element :nav_item, all: true              => [Array or Capybara::Node::Element]
      #     elements :nav_item                        => [Array or Capybara::Node::Element]
      #     elements :logo, within: :header
      #
      def element(name, options={})
        options, search_options = extract_element_options(options)
        selector = "#{options[:append_selector]}#{element_selector_by_name(name)}#{options[:prepend_selector]}"

        # Since `all` just search for matching elements, without timeout
        # to allow element to be rendered, running `wait_until first` that
        # ensures that at least one matching element is rendered
        find_element_within(options[:within]) do
          wait_until { first(selector, search_options) } rescue nil
          elements = all(selector, search_options)
          elements = elements.select { |e| e.visible? } if options[:visible]
          error = Capybara::ElementNotFound.new("unable to find any `#{selector}` #{options.inspect}")

          if options[:all]
            raise error if elements.empty? && options[:greedy]
            elements
          else
            elements[options[:index]] or raise error
          end
        end
      end

      def elements(name, options={})
        element(name, options.merge(all: true))
      end

      def element?(name, options={})
        element(name, options.merge(greedy: true))
        true
      rescue Capybara::ElementNotFound
        false
      end

      alias elements? element?

      def elements_map=(hash)
        raise "Use elements_map= is deprecated elements_map.set instead to assign it to #{hash}"
      end

      def elements_map
        @elements_map ||= ElementsMap.new
      end

      def wait_then_click(&block)
        element = wait_then_sleep(0.5, &block)
        element.click
      end

      def wait_then_sleep(seconds=0.5, &block)
        result = wait_until(&block)
        sleep seconds
        result
      end

      private
      def element_selector_by_name(name)
        elements_map[name] or raise ElementMapNotFoundError, "unable to find element selector for #{name}"
      end

      def extract_element_options(options)
        default_options = {index: 0, all: false, within: nil, visible: true, greedy: true}
        except_keys = %w(all index greedy withing prepend_selector append_selector).map(&:to_sym)
        options = default_options.merge(options)

        [options, hash_without_keys(options, except_keys)]
      end

      def hash_without_keys(hash, exceptions)
        hash.inject({}) do |memo, (k, v)|
          memo[k] = v unless exceptions
          memo
        end
      end

      def find_element_within(within_selector=nil, &block)
        within_selector = element(within_selector) if within_selector.is_a? Symbol

        if within_selector
          within(within_selector, &block)
        else
          yield
        end
      end
    end
  end

  class ElementMapNotFoundError < StandardError
  end

  class ElementsMap < Hash
    def set(hash)
      validate_type!(hash)
      clear
      merge!(hash)
    end

    def merge!(hash)
      super symbolize_keys!(hash)
    end

    private
    def symbolize_keys!(hash)
      hash.inject({}) do |memo, (k, v)|
        memo[k.to_sym] = v
        memo
      end
    end

    def validate_type!(object)
      raise TypeError, "elements_map should be hash" unless object.is_a? Hash
    end


    alias :<< :merge!
  end
end
