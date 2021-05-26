# frozen_string_literal: true

class SmsInvitation < Invitation
  def send_invite(plain_text_token)
    check_attributes
    SendSms.run!(send_sms_attributes(plain_text_token))
  rescue RuntimeError => e
    Appsignal.set_error(e, person_id: invitation_set.person.id)
  end

  private

  def check_attributes
    return unless invitation_set.person.mobile_phone

    raise 'mobile_phone number required for sending text messages'
  end

  def send_sms_attributes(plain_text_token)
    {
      number: invitation_set.person.mobile_phone,
      text: generate_message(plain_text_token),
      reference: generate_reference
    }
  end

  def generate_message(plain_text_token)
    "#{invitation_set.invitation_text} #{invitation_set.invitation_url(plain_text_token)}"
  end

  def generate_reference
    "vsv-#{invitation_set.id}"
  end
end
