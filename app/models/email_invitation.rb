# frozen_string_literal: true

class EmailInvitation < Invitation
  def send_invite(plain_text_token)
    return if invitation_set.person.email.blank? || invitation_set.responses.blank?

    send_invite_email(plain_text_token)
  end

  private

  # Email invitations use the layout of the project and the template of the protocol,
  # if these files exist (see the explanation in README.md under "Organization-specific settings").
  def send_invite_email(plain_text_token)
    # Use the name of the protocol of the first response that the user will see when opening the invitation link.
    template = invitation_set.responses.min_by(&:priority_sorting_metric).protocol_subscription.protocol.name
    mailer = InvitationMailer.invitation_mail(invitation_set.person.email,
                                              invitation_set.invitation_text,
                                              invitation_set.invitation_url(plain_text_token),
                                              template)
    mailer.deliver_now
  end
end
