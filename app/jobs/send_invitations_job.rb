# frozen_string_literal: true

class SendInvitationsJob < ApplicationJob
  queue_as :default

  def perform(invitation_set)
    invitation_text = ''
    invitation_set.reload
    invitation_set.responses.opened_and_not_expired.each do |response|
      invitation_text = random_message(response)
      break
    end
    return if invitation_text.blank?
    invitation_token = invitation_set.invitation_tokens.create!
    plain_text_token = invitation_token.token_plain
    invitation_set.update_attributes!(invitation_text: invitation_text) if invitation_set.invitation_text.blank?
    send_invitations(invitation_set, plain_text_token)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.hour
  end

  private

  def send_invitations(invitation_set, plain_text_token)
    invitation_set.invitations.each do |invitation|
      invitation.sending!
      SendInvitationJob.perform_later(invitation, plain_text_token)
    end
  end

  def random_message(response)
    if response.protocol_subscription.person.mentor?
      mentor_texts(response)
    else
      subs_hash = VariableSubstitutor.substitute_variables(response)
      content = if in_announcement_week
        'Hoi {{deze_student}}, jouw vragenlijst staat weer voor je klaar. Heb je inmiddels zomervakantie? ' \
          'Dat kan je vanaf nu aangeven aangeven in de app.'
      else
        StudentInvitationTexts.message(response.protocol_subscription.protocol,
                                       response.protocol_subscription.protocol_completion)
      end
      VariableEvaluator.evaluate_obj(content, subs_hash)
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
end
