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

    # Recursively checks if all hashes with language keys have both 'nl' and 'en' keys
    # Returns true if valid, false if any hash has only one language key
    def valid_translations?(content)
      return true if content.blank?

      if content.is_a?(Hash)
        # Check if this hash has language keys
        has_nl = content.key?('nl') || content.key?(:nl)
        has_en = content.key?('en') || content.key?(:en)

        # If one language key exists, the other must also exist
        return false if has_nl ^ has_en # XOR: true if only one is true

        # Recursively check all values in the hash
        content.values.each do |value|
          return false unless valid_translations?(value)
        end
        return true
      end

      if content.is_a?(Array)
        content.each do |value|
          return false unless valid_translations?(value)
        end
        return true
      end

      true
    end

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
