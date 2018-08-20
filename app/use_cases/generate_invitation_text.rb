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
    StudentInvitationTexts.message(response)
  end

  def mentor_texts(response)
    MentorInvitationTexts.message(response)
  end
end
