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
    else # Student
      response.substitute_variables(StudentInvitationTexts.message(response.protocol_subscription.protocol,
                                                                   response.protocol_subscription.protocol_completion))
    end
  end

  def target_first_name(response)
    response.protocol_subscription.person.first_name
  end

  def open_questionnaire?(response, questionnaire_name)
    response.protocol_subscription.person.my_open_responses.select do |resp|
      resp.measurement.questionnaire.name == questionnaire_name
    end.count.positive?
  end

  def completed_some?(response)
    person = response.protocol_subscription.person
    Response.where.not(completed_at: nil).where(filled_out_by_id: person.id).count.positive?
  end

  # rubocop:disable Metrics/AbcSize
  def filled_out_mentor_voormeting_last_week?(response)
    return false unless Time.zone.now > Time.new(2018, 5, 10, 9).in_time_zone &&
                        Time.zone.now < Time.new(2018, 5, 14).in_time_zone
    person = response.protocol_subscription.person
    # the following does not work for student voormeting because it is used in multiple measurements
    measurement = Questionnaire.find_by_name('voormeting mentoren').measurements.first
    if measurement.blank?
      Rails.logger.info '[Attention] ERROR: voormeting mentoren questionnaire not found'
      puts 'ERROR: voormeting mentoren questionnaire not found'
      return false
    end
    Response.where('completed_at IS NOT NULL AND completed_at >= :begin_at AND completed_at <= :end_at',
                   begin_at: Time.new(2018, 5, 3, 10).in_time_zone,
                   end_at: Time.new(2018, 5, 10, 9, 59).in_time_zone).where(measurement_id: measurement.id,
                                                                            filled_out_by_id: person.id).count.positive?
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def mentor_texts(response)
    if filled_out_mentor_voormeting_last_week?(response)
      'Bedankt voor je inzet! Door een technische fout kreeg je vorige week een verkeerde ' \
      '\'welkom bij het onderzoek\' sms toegestuurd, maar het onderzoek loopt gewoon door. ' \
      'Onze excuses voor de verwarring. Bij deze weer een link naar de wekelijkse vragenlijst:'
    elsif open_questionnaire?(response, 'voormeting mentoren') && completed_some?(response)
      'Bedankt voor je inzet! Door een technische fout kreeg je vorige week een verkeerde ' \
      '\'welkom bij het onderzoek\' sms toegestuurd, maar het onderzoek loopt gewoon door. ' \
      'Onze excuses voor de verwarring. Als je op de link klikt kom je eerst nog even bij ' \
      'de allereerste vragenlijst (de voormeting), die had je nog niet ingevuld, daarna kom ' \
      'je bij de wekelijkse vragenlijst.'
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
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
end
