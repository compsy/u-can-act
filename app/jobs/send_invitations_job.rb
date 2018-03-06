# frozen_string_literal: true

class SendInvitationsJob < ApplicationJob
  queue_as :default

  def perform(invitation_set)
    any_valid = false
    invitation_text = ''
    invitation_set.reload
    invitation_set.responses.opened_and_not_expired.each do |response|
      invitation_text = random_message(response)
      any_valid = true
      break
    end
    return unless any_valid
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
    else # Student
      response.substitute_variables(StudentInvitationTexts.message(response.protocol_subscription.protocol,
                                                                   response.protocol_subscription.protocol_completion))
    end
  end

  def target_first_name(response)
    response.protocol_subscription.person.first_name
  end

  def mentor_texts(response)
    if response.measurement.questionnaire.name.match?(/voormeting/)
      "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
      'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
      'Morgen start de eerste wekelijkse vragenlijst. Succes!'
    elsif response.protocol_subscription.responses.invited.empty? # voormeting is in different protsub
      'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
       'Vul nu de eerste wekelijkse vragenlijst in.'
    else
      "Hoi #{target_first_name(response)}, je wekelijkse vragenlijsten staan weer voor je klaar!"
    end
  end
end
