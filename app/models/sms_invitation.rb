class SmsInvitation < Invitation
  def send(plain_text_token)
    raise 'sending sms'
  end

  private

  def send_sms_attributes
    {
      number: invitation_set.person.mobile_phone,
      text: generate_message(plain_text_token),
      reference: generate_reference
    }
  end

  def generate_reference
    "vsv-#{response.id}"
  end
end
