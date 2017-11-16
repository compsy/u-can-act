# frozen_string_literal: true

class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    response.initialize_invitation_token!
    SendSms.run!(send_sms_attributes)
  end

  private

  def send_sms_attributes
    {
      number: response.protocol_subscription.person.mobile_phone,
      text: generate_message,
      reference: generate_reference
    }
  end

  def generate_message
    "#{random_message} #{invitation_url}"
  end

  def random_message
    if response.protocol_subscription.person.role.group == Person::STUDENT
      student_texts
    else # Mentor
      mentor_texts
    end
  end

  def student_texts
    if response.measurement.questionnaire.name.match?(/voormeting/)
      "Welkom bij de kick-off van het onderzoek 'u-can-act'. Fijn dat je " \
      'meedoet! Vandaag starten we met een aantal korte vragen, morgen begint ' \
      'de wekelijkse vragenlijst. Via de link kom je bij de vragen en een ' \
      'filmpje met meer info over u-can-act. Succes!'
    elsif response.protocol_subscription.responses.invited.length == 1
      'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'
    else
      'Fijn dat jij meedoet! Door jou kunnen jongeren nog betere begeleiding krijgen in de toekomst!'
    end
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
      'Heel fijn dat je meedoet aan u-can-act! De volgende wekelijkse vragenlijst staat voor je klaar.'
    end
  end

  def invitation_url
    "#{ENV['HOST_URL']}/?q=#{response.invitation_token.token}"
  end

  def generate_reference
    "vsv-#{response.id}"
  end
end
