# frozen_string_literal: true

class OneTimeResponseController < ApplicationController
  before_action :load_one_time_response, only: :show
  before_action :create_person, only: :show
  before_action :subscribe_person, only: :show

  def show
    redirect_to @one_time_response.redirect_url(@person)
  end

  private

  def create_person
    @person = CreateAnonymousPerson.run!(
      team_name: Rails.application.config.settings.default_team_name
    )
  end

  def subscribe_person
    @one_time_response.subscribe_person(@person)
  end

  def load_one_time_response
    token = one_time_response_params[:q]
    # This route only works for non-restricted OTRs, because the restricted ones cannot be filled out anonymously.
    @one_time_response = OneTimeResponse.find_by(token: token, restricted: false)
    return @one_time_response if @one_time_response.present?

    render(status: :not_found, html: 'De vragenlijst kon niet gevonden worden.', layout: 'application')
  end

  def one_time_response_params
    params.permit(:q)
  end
end
