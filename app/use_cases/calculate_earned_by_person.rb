# frozen_string_literal: true

class CalculateEarnedByPerson < ActiveInteraction::Base
  object :person

  # Calculates the amount of money a person has earned
  #
  # Params:
  # - person: the person for which to calculate the reward
  def execute
    # If we, in the future, would like to include the mentoring protocol subscriptions
    # here as well (for example, if they would also receive a reward), make sure to also
    # take the protocol transfers into account, in order to generate a fair estimate.
    person.protocol_subscriptions.select(&:for_myself?)
    prot_subs.sum(&:earned_euros)
  end
end
