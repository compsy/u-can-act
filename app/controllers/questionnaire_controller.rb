# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  before_action :set_response

  def show; end

  private

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @response = invitation_token.response
    response_opened!
  end

  def questionnaire_params
    params.permit(:q)
  end

  def response_opened!
    @response.opened_at = Time.zone.now
    @response.save!
  end

  def check_invitation_token(invitation_token)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless invitation_token
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if
      invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if invitation_token.response.expired?
  end
end
