module Capybarel
  class ElementsMapError < StandardError
  end

  class ElementSelectorNotFoundError < StandardError
  end

  module DSL

    include Capybara::DSL

    def element(name, options={})
      options, search_options = extract_element_options(options)
      selector = "#{options[:append_selector]}#{element_selector_by_name(name)}#{options[:prepend_selector]}"

      # Since `all` just search for matching elements, without timeout
      # to allow element to be rendered, running `wait_until first` that
      # ensures that at least one matching element is rendered
      find_element_within(options[:within]) do
        wait_until { first(selector, search_options) } rescue nil
        elements = all(selector, search_options)
        elements = elements.select {|e| e.visible? } if options[:visible]

        if options[:all]
          raise Capybara::ElementNotFound, "unable to find any `#{selector}` #{options.inspect}" if elements.empty? && options[:greedy]
          elements
        else
          elements[options[:index]] or raise Capybara::ElementNotFound, "unable to find `#{selector}` #{options.inspect}"
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

    def element_selector_by_name(name)
      elements_map[name] or raise ElementSelectorNotFoundError, "unable to find element selector for #{name}"
    end

    def elements_map=(map)
      validate_elements_map! map
      @_elements_map = map
    end

    def elements_map
      @_elements_map ||= {}
    end

    def merge_elements_map(map)
      validate_elements_map! map
      @_elements_map.merge! map
    end

    def reset_elements_map
      @_elements_map = {}
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

    def screenshot
      # TODO
    end

    private
    def extract_element_options(options)
      default_options = {index: 0, all: false, within: nil, visible: true, greedy: false}
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

    def validate_elements_map!(map)
      raise ElementsMapError, "elements_map should be hash" unless map.is_a? Hash
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
