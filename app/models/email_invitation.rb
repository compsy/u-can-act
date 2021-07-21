# frozen_string_literal: true

class EmailInvitation < Invitation
  def send_invite(plain_text_token)
    return if invitation_set.person.email.blank?

    send_invite_email(plain_text_token)
  end

  private

  def send_invite_email(plain_text_token)
    mailer = InvitationMailer.invitation_mail(invitation_set.person.email,
                                              invitation_set.invitation_text,
                                              invitation_set.invitation_url(plain_text_token),
                                              invitation_set.responses.first.protocol_subscription.protocol.name)
    mailer.deliver_now
  end
end
