# frozen_string_literal: true

class OneTimeResponseController < ApplicationController
  before_action :load_one_time_response, only: :show
  before_action :create_person, only: :show
  before_action :subscribe_person, only: :show

  def show 
    redirect_to get_redirect_url
  end

  private

  def create_person
		team_name = 'Controlegroep'
		@person = CreateAnonymousUser.run!(team_name: team_name)
  end

  def subscribe_person
    Rails.logger.info @one_time_response.protocol	
    Rails.logger.info @person.inspect	
    SubscribeToProtocol.run!(protocol: @one_time_response.protocol, 
                             person: @person,
                             start_date: 10.minutes.ago.in_time_zone)
  end

  def get_redirect_url
    byebug
    invitation_set = InvitationSet.create!(person_id: @person.id, 
                                           responses: @person.my_open_responses)
    invitation_token = invitation_set.invitation_tokens.create!
    invitation_set.invitation_url(invitation_token.token_plain)
  end


  def load_one_time_response
    token = one_time_response_params[:tok]
    @one_time_response = OneTimeResponse.find_by_token(token)
    return @one_time_response if @one_time_response.present?

    render(status: 404, html: 'De vragenlijst kon niet gevonden worden.', layout: 'application')
  end

  def one_time_response_params
    params.permit(:tok)
  end
end
