# frozen_string_literal: true

class LanguagesController < ApplicationController
  # protect_from_forgery prepend: true, with: :exception, except: :create
  # skip_before_action :verify_authenticity_token, only: %i[interactive_render from_json]
  # before_action :log_csrf_error, only: %i[create]
  # before_action :set_response, only: %i[show preference destroy]
  # before_action :set_locale, only: %i[show]

  before_action :set_response, only: %i[change]

  def show
    @locale = current_user.locale
    @callback = show_params[:cb]
    @response_id = show_params[:r_id]
  end

  def change
    @locale = change_params[:locale]
    unless current_user.update locale: @locale == 'nl' ? 'nl' : 'en'
      Rails.logger.error "invalid user: #{current_user.errors.full_messages}"
      return flash.alert = I18n.t('pages.languages.flash_messages.alert.locale_update_error')
    end

    unless @response.protocol_subscription.update has_language_input: true
      Rails.logger.error "invalid protocol_subscription: #{@response.errors.full_messages}"
      return flash.alert = I18n.t('pages.languages.flash_messages.alert.locale_update_error')
    end

    flash.notice = I18n.t('pages.languages.flash_messages.notice.locale_updated')
    return redirect_to change_params[:cb] if params[:cb].present?

    redirect_to language_path show_params
  end

  private

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
