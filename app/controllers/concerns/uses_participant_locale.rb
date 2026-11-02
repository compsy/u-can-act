# frozen_string_literal: true

# Renders participant-facing pages (including flash messages and the layout) in the language of the participant.
# Without a logged in person, the first browser language that we support is used, and otherwise the default (nl).
module UsesParticipantLocale
  extend ActiveSupport::Concern

  included do
    around_action :use_participant_locale
  end

  private

  def use_participant_locale(&block)
    I18n.with_locale(participant_locale, &block)
  end

  def participant_locale
    person_locale = current_user&.locale
    return person_locale if available_locale?(person_locale)

    browser_locale || I18n.default_locale
  end

  def browser_locale
    request.headers['Accept-Language'].to_s.split(',').each do |entry|
      locale = entry.split(';').first.to_s.strip.split('-').first.to_s.downcase
      return locale if available_locale?(locale)
    end
    nil
  end

  def available_locale?(locale)
    locale.present? && I18n.available_locales.map(&:to_s).include?(locale.to_s)
  end
end
