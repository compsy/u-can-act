# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  before_action :set_response

  def show; end

  private

  def set_response
    invitation_token = InvitationToken.find_by_token(questionnaire_params[:q])
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') and return unless invitation_token
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') and return if invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') and return if invitation_token.response.expired?
    @response = invitation_token.response
    @response.opened_at = Time.zone.now
    @response.save!
  end

  def questionnaire_params
    params.permit(:q)
  end
end
