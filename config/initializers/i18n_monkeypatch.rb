require "i18n-js"

# This is needed to be able to require the generated translations.js into webpacker.

module I18n
  module JS
    module Formatters
      class JS < Base
        def header
          %(import I18n from './i18n'\n#{@namespace}.translations || (#{@namespace}.translations = {});\n)
        end
      end
    end
  end
end
