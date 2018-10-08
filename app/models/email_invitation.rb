# frozen_string_literal: true

class EmailInvitation < Invitation
  def send_invite(plain_text_token)
    return unless invitation_set.person.email.present?

    send_invite_email(plain_text_token)
  end

  private

  def send_invite_email(plain_text_token)
    mailer = InvitationMailer.invitation_mail(invitation_set.person.email,
                                              invitation_set.invitation_text,
                                              invitation_set.invitation_url(plain_text_token))
    mailer.deliver_now
  end
end
