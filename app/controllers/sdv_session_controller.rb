# frozen_string_literal: true

class SdvSessionController < ApplicationController
  def show
    response.headers['Cache-Control'] = 'no-store'
    head(current_user.present? ? :no_content : :unauthorized)
  end
end
