# frozen_string_literal: true

class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    response.initialize_invitation_token!
    person = response.protocol_subscription.person

    SendSms.run!(send_sms_attributes)
    send_email(person.email, random_message, invitation_url) if person.mentor?
  end

  private

  def send_email(email, message, invitation_url)
    return unless email.present?
    mailer = InvitationMailer.invitation_mail(email, message, invitation_url)
    mailer.deliver_now
  end

  def send_sms_attributes
    {
      number: response.protocol_subscription.person.mobile_phone,
      text: generate_sms_message,
      reference: generate_reference
    }
  end

  def generate_sms_message
    "#{random_message} #{invitation_url}"
  end

  def random_message
    if response.protocol_subscription.person.mentor?
      mentor_texts
    else # Student
      response.substitute_variables(InvitationTexts.student_message(response.protocol_subscription.protocol,
                                                                    response.protocol_subscription.protocol_completion))
    end
  end

  def target_first_name
    response.protocol_subscription.person.first_name
  end

  def mentor_texts
    if response.measurement.questionnaire.name.match?(/voormeting/)
      "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
      'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
      'Morgen start de eerste wekelijkse vragenlijst. Succes!'
    elsif response.protocol_subscription.responses.invited.empty? # voormeting is in different protsub
      'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
       'Vul nu de eerste wekelijkse vragenlijst in.'
    else
      "Hoi #{target_first_name}, je wekelijkse vragenlijsten staan weer voor je klaar!"
    end
  end

  def invitation_url
    "#{ENV['HOST_URL']}/?q=#{response.invitation_token.token}"
  end

  def generate_reference
    "vsv-#{response.id}"
  end
end
