# frozen_string_literal: true

class QuestionnaireTranslator
  # Content that is translated to this pseudo locale gets language independent labels (see QuestionnaireGenerator).
  # It is optional, so there is no fallback for it.
  I18N_LOCALE = 'i18n'
  # Users only get a questionnaire in their own language or in English. nl is a last resort (e.g. for an admin
  # preview), since every translated text has an nl translation.
  FALLBACK_LOCALES = %w[en nl].freeze
  REQUIRED_LOCALE = 'nl'

  class << self
    # Returns a translated copy of the content. A translation hash is replaced by its translation for the locale, or
    # by the first fallback locale that it has.
    def translate_content(content, locale)
      translate_content_aux(content.deep_dup, locale_chain(locale))
    end

    # Returns true if the content has a text that is translated in more than one language.
    def multi_language?(content)
      each_translation(content) do |translation|
        return true if language_keys(translation).size > 1
      end
      false
    end

    # Returns the languages (as strings) used anywhere in the content, e.g. %w[nl en fi].
    def languages(content)
      found = Set.new
      each_translation(content) { |translation| found.merge(language_keys(translation)) }
      found.to_a
    end

    # Returns true if every translated text in the content can be shown in the locale or in English, so that
    # a user with this locale never sees a text in another language.
    def available_in?(content, locale)
      locales = [locale.to_s, 'en']
      each_translation(content) do |translation|
        return false if (language_keys(translation) & locales).empty?
      end
      true
    end

    # Recursively checks that every hash with language keys has an 'nl' key. Other languages are optional.
    def valid_translations?(content)
      each_translation(content) do |translation|
        return false unless language_keys(translation).include?(REQUIRED_LOCALE)
      end
      true
    end

    private

    def locale_chain(locale)
      locale = locale.to_s
      return [locale] if locale == I18N_LOCALE

      ([locale] + FALLBACK_LOCALES).uniq
    end

    def translate_content_aux(content, locales)
      return content if content.blank?
      return translate_hash(content, locales) if content.is_a?(Hash)
      return content.map { |value| translate_content_aux(value, locales) } if content.is_a?(Array)

      content
    end

    def translate_hash(content, locales)
      # replace with translation
      locales.each do |locale|
        return translate_content_aux(content[locale], locales) if content.key?(locale)
        return translate_content_aux(content[locale.to_sym], locales) if content.key?(locale.to_sym)
      end

      content.keys.each do |key|
        content[key] = translate_content_aux(content[key], locales)
      end
      content
    end

    # Yields every hash in the content that has at least one language key.
    def each_translation(content, &block)
      if content.is_a?(Hash)
        yield content if language_keys(content).any?
        content.each_value { |value| each_translation(value, &block) }
      elsif content.is_a?(Array)
        content.each { |value| each_translation(value, &block) }
      end
    end

    def language_keys(hash)
      hash.keys.map(&:to_s) & I18n.available_locales.map(&:to_s)
    end
  end
end
