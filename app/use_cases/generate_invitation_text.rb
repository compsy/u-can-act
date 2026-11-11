# frozen_string_literal: true

class GenerateInvitationText < ActiveInteraction::Base
  object :response

  # The protocol and project fallback texts are Dutch.
  DEFAULT_TEXT_LOCALE = 'nl'

  # Generates an invitation text based on the protocol and the completion therof
  #
  # Params:
  # - response: the response to create the text for
  def execute
    subs_hash = VariableSubstitutor.substitute_variables(response)
    text_locale, content = localized_text(response) || [DEFAULT_TEXT_LOCALE, default_text(response)]
    # Dates in the text (e.g. {{datum}}) are written in the language of the invitation text
    I18n.with_locale(text_locale) { VariableEvaluator.evaluate_obj(content, subs_hash) }
  end

  private

  # The invitation text of the protocol subscription in the participant's locale, falling back to en and then nl.
  def localized_text(response)
    protocol_subscription = response.protocol_subscription
    protocol_subscription.localized_invitation_text(protocol_subscription.person.locale)
  end

  def default_text(response)
    protocol_text = response.protocol_subscription.protocol.invitation_text
    return protocol_text if protocol_text.present?

    return UcfMessages.message(response) if ENV['PROJECT_NAME'] == 'u-can-feel'

    return mentor_texts(response) if response.protocol_subscription.person.mentor?

    student_texts(response)
  end

  def student_texts(response)
    StudentInvitationTexts.message(response)
  end

  def mentor_texts(response)
    MentorInvitationTexts.message(response)
  end
end
