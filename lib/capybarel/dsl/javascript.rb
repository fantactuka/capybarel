module Capybarel
  module DSL
    module JavaScript

      def js_touch_to_click
        page.execute_script <<-CODE
          document.addEventListener("click", function(ev) {
            var e = document.createEvent("UIEvents");
            e.initUIEvent("touchend", true, true, window, 1);
            ev.target.dispatchEvent(e);
          });
        CODE
      end

      def js_reject_webkit_full_screen
        page.execute_script <<-CODE
          if (window.HTMLVideoElement) {
            window.HTMLVideoElement.prototype.webkitRequestFullScreen = function() {};
            window.HTMLVideoElement.prototype.webkitEnterFullScreen = function() {};
          }
        CODE
      end
    end
  end
end
