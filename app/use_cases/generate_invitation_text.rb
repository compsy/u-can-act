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
    result = Compsy::MicroserviceApi::CallService.run! action: 'svc-messages',
                                                       namespace: ENV['MICROSERVICE_NAMESPACE'],
                                                       parameters: generate_hash(response)
    result.response['result']['payload']
  end

  def generate_hash(response)
    hash = {}
    hash[:person] = person_hash(response)
    hash[:response] = response_hash(response)
    hash[:protocol_subscription] = protocol_subscription_hash(response)
    hash
  end

  def person_hash(response)
    {
      group: response.person.role.group,
      first_name: 'UNUSED!'
    }
  end

  def response_hash(response)
    {
      questionnaire_name: response.measurement.questionnaire.name,
      open_questionnaires: response.person.my_open_responses.map { |x| x.measurement.questionnaire.name }
    }
  end

  def protocol_subscription_hash(response)
    protocol_completion = response.protocol_subscription.completion

    {
      invitations: response.protocol_subscription.responses.invited.count,
      protocol_completion: protocol_completion,
      protocol: protocol_hash(response, protocol_completion)
    }
  end

  def protocol_hash(response, protocol_completion)
    curidx = protocol_completion.find_index { |entry| entry[:future] } || -1
    current_protocol_completion = protocol_completion[0..curidx]
    protocol = response.protocol_subscription.protocol
    current_reward = protocol.calculate_reward(current_protocol_completion, false)
    maximum_reward = protocol.calculate_reward(current_protocol_completion, true)
    {
      name: protocol.name,
      current_reward: current_reward,
      maximum_reward: maximum_reward,
      streak_threshold: Protocol.find_by_name('studenten')&.rewards&.second&.threshold || 3
    }
  end
end
