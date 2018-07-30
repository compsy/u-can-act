# frozen_string_literal: true

class CalculateMaximumEurosByPerson < ActiveInteraction::Base
  object :person

  # Calculates the maximum amount of euros a person can earn
  #
  # Params:
  # - person: the person for which to calculate the reward
  def execute
    # If we, in the future, would like to include the mentoring protocol subscriptions
    # here as well (for example, if they would also receive a reward), make sure to also
    # take the protocol transfers into account, in order to generate a fair estimate.
    prot_subs = person.protocol_subscriptions.select(&:for_myself?)
    prot_subs.sum { |x| x.earned_euros(true) }
  end
end
