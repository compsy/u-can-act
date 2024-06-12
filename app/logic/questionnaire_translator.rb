# frozen_string_literal: true

class QuestionnaireTranslator
  class << self
    def translate_content(content, locale)
      @locale = locale
      translate_content_aux(content)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def multi_language?(content)
      return false if content.blank?

      if content.is_a?(Hash)
        return true if (content.key?('nl') && content.key?('en')) || (content.key?(:nl) && content.key?(:en))

        content.keys.each do |key|
          return true if multi_language?(content[key])
        end
        return false
      end

      if content.is_a?(Array)
        content.each do |value|
          return true if multi_language?(value)
        end
        return false
      end

      false
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity

    private

    def translate_content_aux(content)
      return content if content.blank?

      if content.is_a?(Hash)
        # replace with translation
        return translate_content_aux(content[@locale]) if content.key?(@locale)

        return translate_content_aux(content[@locale.to_sym]) if content.key?(@locale.to_sym)

        content.keys.each do |key|
          content[key] = translate_content_aux(content[key])
        end
        return content
      end
      return content.map { |value| translate_content_aux(value) } if content.is_a?(Array)

      content
    end
  end
end
