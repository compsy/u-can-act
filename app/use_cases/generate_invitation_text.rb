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
    invitation_text = generate_localized_text(response)
    return invitation_text if invitation_text.present?

    return UcfMessages.message(response) if ENV['PROJECT_NAME'] == 'u-can-feel'

    return mentor_texts(response) if response.protocol_subscription.person.mentor?

    student_texts(response)
  end

  # There are only nl and en invitation texts, so every locale other than nl gets the en text.
  def generate_localized_text(response)
    protocol_subscription = response.protocol_subscription
    localized_text = if protocol_subscription.person.locale == 'nl'
                       protocol_subscription.invitation_text_nl
                     else
                       protocol_subscription.invitation_text_en
                     end
    localized_text.presence || protocol_subscription.protocol.invitation_text
  end

  def student_texts(response)
    StudentInvitationTexts.message(response)
  end

  def mentor_texts(response)
    MentorInvitationTexts.message(response)
  end
end
