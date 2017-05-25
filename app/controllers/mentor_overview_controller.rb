class MentorOverviewController < ApplicationController
  before_action :set_mentor
  def show
    @my_protocol_subscriptions = @mentor.my_protocols
    @student_protocol_subscriptions = @mentor.student_protocols
  end

  private

  def mentor_params
    params.permit(:q)
  end

  def set_mentor
    invitation_token = InvitationToken.find_by_token(mentor_params[:q])
    check_invitation_token(invitation_token)
    return if performed?
    @mentor = invitation_token.response.protocol_subscription.person
  end

  def check_invitation_token(invitation_token)
    render(status: 404, plain: 'De vragenlijst kon niet gevonden worden.') && return unless invitation_token
    render(status: 404, plain: 'Je hebt deze vragenlijst al ingevuld.') && return if
      invitation_token.response.completed_at
    render(status: 404, plain: 'Deze vragenlijst kan niet meer ingevuld worden.') if invitation_token.response.expired?
  end
end
