# frozen_string_literal: true

class LanguagesController < ApplicationController
  # nl and en are always offered, as before. Other locales are only offered when the questionnaire of the response
  # is available in them, so other projects keep offering just nl and en.
  DEFAULT_LOCALES = %w[nl en].freeze

  before_action :set_response, only: %i[change]

  def show
    @locale = current_user.locale
    @callback = show_params[:cb]
    @response_id = show_params[:r_id]
    @locales = selectable_locales(current_user.responses.find_by(id: @response_id))
    # Preselect en when the user's locale is not offered (e.g. fi on an nl/en questionnaire), like the fallbacks do.
    @locale = 'en' unless @locales.include?(@locale)
  end

  # rubocop:disable Metrics/AbcSize
  def change
    @locale = change_params[:locale]
    locale = selectable_locales(@response).include?(@locale) ? @locale : 'en'
    unless current_user.update locale: locale
      Rails.logger.error "invalid user: #{current_user.errors.full_messages}"
      return flash.alert = I18n.t('pages.languages.flash_messages.alert.locale_update_error')
    end

    unless @response.protocol_subscription.update has_language_input: true
      Rails.logger.error "invalid protocol_subscription: #{@response.errors.full_messages}"
      return flash.alert = I18n.t('pages.languages.flash_messages.alert.locale_update_error')
    end

    flash.notice = I18n.t('pages.languages.flash_messages.notice.locale_updated')
    return redirect_to change_params[:cb], allow_other_host: true if params[:cb].present?

    redirect_to language_path show_params
  end
  # rubocop:enable Metrics/AbcSize

  private

  def selectable_locales(response)
    content = response&.measurement&.questionnaire&.content
    questionnaire_locales = QuestionnaireTranslator.languages(content).select do |locale|
      QuestionnaireTranslator.available_in?(content, locale)
    end
    I18n.available_locales.map(&:to_s) & (DEFAULT_LOCALES + questionnaire_locales)
  end

  def show_params
    params.permit(:cb, :r_id)
  end

  def change_params
    params.permit(:locale, :cb, :r_id)
  end

  def set_response
    @response = current_user.responses.find_by id: change_params[:r_id]

    alert_msg = I18n.t('pages.languages.flash_messages.alert.response_not_found')
    redirect_to language_path, alert: alert_msg if @response.blank?
  end
end
