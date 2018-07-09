# frozen_string_literal: true

class GenerateInvitationText < ActiveInteraction::Base
  object :response

  # Generates an invitation text based on the protocol and the completion therof
  #
  # Params:
  # - response: the response to create the text for
  def execute
    subs_hash = VariableSubstitutor.substitute_variables(response)
    content = generate_text(response)
    VariableEvaluator.evaluate_obj(content, subs_hash)
  end

  private

  def generate_text(response)
    invitation_text = response.protocol_subscription.protocol.invitation_text
    return invitation_text if invitation_text.present?
    return mentor_texts(response) if response.protocol_subscription.person.mentor?
    student_texts(response)
  end

  def student_texts(response)
    if in_announcement_week
      return 'Hoi {{deze_student}}, jouw vragenlijst staat weer voor je klaar. Heb je inmiddels zomervakantie? ' \
        'Dat kan je vanaf nu aangeven aangeven in de app.'
    end
    StudentInvitationTexts.message(response.protocol_subscription.protocol,
                                   response.protocol_subscription.protocol_completion)
  end

  def mentor_texts(response)
    if open_questionnaire?(response, 'voormeting mentoren') && completed_some?(response)
      'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze ' \
      'week ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ' \
      'ingevuld. Na het invullen hiervan kom je weer bij de wekelijkse vragenlijst.'
    elsif open_questionnaire?(response, 'voormeting mentoren') && !completed_some?(response)
      "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
      'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
      'Morgen start de eerste wekelijkse vragenlijst. Succes!'
    elsif response.protocol_subscription.responses.invited.count == 1 # voormeting is in different protsub
      'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
       'Vul nu de eerste wekelijkse vragenlijst in.'
    else
      "Hoi #{target_first_name(response)}, je wekelijkse vragenlijsten staan weer voor je klaar!"
    end
  end

  def in_announcement_week
    Time.zone.now > Time.new(2018, 6, 27).in_time_zone &&
      Time.zone.now < Time.new(2018, 7, 4).in_time_zone
  end

  def target_first_name(response)
    response.protocol_subscription.person.first_name
  end

  def open_questionnaire?(response, questionnaire_name)
    person = response.protocol_subscription.person
    person.open_questionnaire?(questionnaire_name)
  end

  def completed_some?(response)
    person = response.protocol_subscription.person
    person.responses.completed.count.positive?
  end
end
