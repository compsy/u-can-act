# frozen_string_literal: true

module RewardHelper
  def as_percentage(numa, numb)
    (100 * numa / Float(numb)).round(0).to_s
  end

  def mentor?
    @protocol_subscription.person.mentor?
  end
end
