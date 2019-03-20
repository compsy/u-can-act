require "i18n-js"

# This is needed to be able to require the generated translations.js into webpacker.

module I18n
  module JS
    class Segment
      protected
      def js_header
        %(import I18n from './i18n'\n#{@namespace}.translations || (#{@namespace}.translations = {});\n)
      end
    end
  end
end

module I18n
  module JS
    module Formatters
      class Base
      end
      class JS < Base
        protected
        def header
          %(import I18n from './i18n'\n#{@namespace}.translations || (#{@namespace}.translations = {});\n)
        end
      end
    end
  end
end
