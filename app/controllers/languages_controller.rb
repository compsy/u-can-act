# frozen_string_literal: true

class LanguagesController < ApplicationController
  # protect_from_forgery prepend: true, with: :exception, except: :create
  # skip_before_action :verify_authenticity_token, only: %i[interactive_render from_json]
  # before_action :log_csrf_error, only: %i[create]
  # before_action :set_response, only: %i[show preference destroy]
  # before_action :set_locale, only: %i[show]

  def show
    @locale = current_user.locale
  end

  def change
    @locale = change_params[:locale]
    current_user.update! locale: @locale == 'nl' ? 'nl' : 'en'
  end

  private

  def change_params
    params.permit(:locale)
  end
end
