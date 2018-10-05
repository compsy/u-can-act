# frozen_string_literal: true

class OneTimeResponseController < ApplicationController
  before_action :load_one_time_response, only: :show
  before_action :create_person, only: :show
  before_action :subscribe_person, only: :show

  def show
    redirect_to redirect_url
  end

  private

  def create_person
    @person = CreateAnonymousPerson.run!(
      team_name: Rails.application.config.settings.default_team_name
    )
  end

  def subscribe_person
    protocol_subscription = SubscribeToProtocol.run!(protocol: @one_time_response.protocol,
                                                     person: @person)
    RescheduleResponses.run!(protocol_subscription: protocol_subscription,
                             future: 10.minutes.ago)
  end

  def redirect_url
    invitation_set = InvitationSet.create!(person_id: @person.id,
                                           responses: @person.my_open_responses)
    invitation_token = invitation_set.invitation_tokens.create!
    invitation_set.invitation_url(invitation_token.token_plain, false)
  end

  def load_one_time_response
    token = one_time_response_params[:t]
    @one_time_response = OneTimeResponse.find_by_token(token)
    return @one_time_response if @one_time_response.present?

    render(status: 404, html: 'De vragenlijst kon niet gevonden worden.', layout: 'application')
  end

  def one_time_response_params
    params.permit(:t)
  end
end
