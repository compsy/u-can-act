# frozen_string_literal: true

module QuestionnaireHelper
  def check_to_send_confirmation_email
    return unless valid_registration?

    registration = get_registration_hash(@response.values)
    message = <<~ENDL
      <p>Beste #{registration[:first_name]},<br>
      Bedankt voor je aanmelding.</p>
      <p><strong>Naam:</strong> #{registration[:name]}</p>
      <p><strong>Functie:</strong> #{registration[:function]}</p>
      <p><strong>Affiliatie:</strong> #{registration[:affiliation]}</p>
      #{registration[:diet]}
      <p>Voor meer informatie, aanpassingen of vragen,
      stuur een mailtje naar Lucia Boer <a href="mailto:info@u-can-act.nl" style="color:#039be5">info@u-can-act.nl</a>.</p>
    ENDL
    InvitationMailer.confirmation_mail(registration[:email_address],
                                       'Bevestiging aanmelding u-can-act symposium op donderdag 16 mei 2019',
                                       message).deliver_now
  end

  def valid_registration?
    @response.protocol_subscription.person.role.group == Person::SOLO &&
      /\A[^@\s]+@[^@\s]+\z/ =~ @response.values['v6']
  end

  def get_registration_hash(hsh)
    {
      email_address: hsh['v6'],
      first_name: hsh['v1'],
      name: "#{hsh['v1']} #{hsh['v2']} #{hsh['v3']}",
      function: hsh['v4'],
      affiliation: hsh['v5'],
      diet: get_diet(hsh)
    }
  end

  def get_diet(hsh)
    msg = ''
    msg += 'Vegetarisch: ✓<br>' if hsh['v8_vegetarisch'] == 'true'
    msg += 'Veganist: ✓<br>' if hsh['v8_veganist'] == 'true'
    msg += 'Glutenvrij: ✓<br>' if hsh['v8_glutenvrij'] == 'true'
    msg += "Anders: #{hsh['v8_anders_namelijk_text']}<br>" if hsh['v8_anders_namelijk'] == 'true'
    return '' if msg.blank?

    "<p><strong>Dieetwensen:</strong><br>#{msg}</p>"
  end
end
