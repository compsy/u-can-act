# frozen_string_literal: true

class SendInvitationsJob < ApplicationJob
  queue_as :default

  def perform(invitation_set)
    invitation_set.reload

    if invitation_set.invitation_text.blank?
      invitation_text = create_invitation_text(invitation_set)
      return if invitation_text.blank?
      invitation_set.update_attributes!(invitation_text: invitation_text)
    end

    finalize_and_schedule_invitation_set(invitation_set)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.hour
  end

  private

  def create_invitation_text(invitation_set)
    invitation_set.responses.opened_and_not_expired.each do |response|
      return GenerateInvitationText.run!(response: response)
    end
  end

  def finalize_and_schedule_invitation_set(invitation_set)
    invitation_token = invitation_set.invitation_tokens.create!
    plain_text_token = invitation_token.token_plain
    send_invitations(invitation_set, plain_text_token)
  end

  def send_invitations(invitation_set, plain_text_token)
    invitation_set.invitations.each do |invitation|
      invitation.sending!
      SendInvitationJob.perform_later(invitation, plain_text_token)
    end
  end
end
