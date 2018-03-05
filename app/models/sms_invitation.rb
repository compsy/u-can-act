# frozen_string_literal: true

class SmsInvitation < Invitation
  def send(plain_text_token)
    SendSms.run!(send_sms_attributes(plain_text_token))
  end

  private

  def send_sms_attributes(plain_text_token)
    {
      number: invitation_set.person.mobile_phone,
      text: generate_message(plain_text_token),
      reference: generate_reference
    }
  end

  def generate_reference
    "vsv-#{invitation_set.id}"
  end
end
