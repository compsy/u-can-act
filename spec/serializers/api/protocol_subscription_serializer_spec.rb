# frozen_string_literal: true

require 'rails_helper'

describe Api::ProtocolSubscriptionSerializer do
  subject(:json) { described_class.new(protocol_subscription).as_json.with_indifferent_access }

  before do
    Timecop.freeze(2017, 2, 1)
  end

  let!(:protocol) { FactoryBot.create(:protocol, :with_rewards) }
  let!(:protocol_subscription) { FactoryBot.create(:protocol_subscription, protocol: protocol) }
  let!(:responses) do
    [FactoryBot.create(:response, :completed,
                       protocol_subscription: protocol_subscription, open_from: 8.days.ago.in_time_zone),
     FactoryBot.create(:response, :invited,
                       protocol_subscription: protocol_subscription, open_from: 7.days.ago.in_time_zone)]
  end

  let!(:streak_responses) do
    # Streak
    (1..7).map do |day|
      FactoryBot.create(:response,
                        :completed,
                        protocol_subscription: protocol_subscription,
                        open_from: day.days.ago.in_time_zone)
    end
  end

  let!(:future_responses) do
    (1..5).map do |day|
      FactoryBot.create(:response,
                        protocol_subscription: protocol_subscription, open_from: day.days.from_now.in_time_zone)
    end
  end

  it 'has the correct initialization' do
    protocol_subscription.reload
    expect(protocol_subscription.responses.length).to eq(6 + 6 + 2)
  end

  describe 'renders the correct json' do
    it 'contains the correct variables' do
      # Mock the actual calculation
      expect_any_instance_of(Protocol).to receive(:calculate_reward)
        .with(protocol_subscription.protocol_completion, false)
        .and_return(321)

      # Mock the actual calculation
      start = responses.length + streak_responses.length
      endd = start + protocol_subscription.responses.future.length
      slice = (start..endd)
      expect_any_instance_of(Protocol).to receive(:calculate_reward)
        .with(protocol_subscription.protocol_completion.slice(slice), true)
        .and_return(123)

      index = responses.length + streak_responses.length - 1
      expect_any_instance_of(Protocol).to receive(:calculate_reward)
        .with([protocol_subscription.protocol_completion[index]])
        .and_return(888)
      json = described_class.new(protocol_subscription).as_json.with_indifferent_access

      expect(json[:person_type]).to eq protocol_subscription.person.role.group
      expect(json[:earned_euros]).to eq 3.21
      expect(json[:euro_delta]).to eq 888
      expect(json[:max_still_awardable_euros]).to eq 123

      completions_strings = protocol_subscription.protocol_completion.map(&:stringify_keys)
      expect(json[:protocol_completion]).to eq completions_strings
    end

    describe 'max_streak' do
      it 'contains a hash with the max achievable streak if there is one' do
        expect(json[:max_streak]).not_to be_nil

        expect(json[:max_streak][:threshold]).not_to be_nil
        expect(json[:max_streak][:threshold]).to eq(protocol_subscription.protocol.max_streak.threshold)

        expect(json[:max_streak][:reward_points]).not_to be_nil
        expect(json[:max_streak][:reward_points]).to eq(protocol_subscription.protocol.max_streak.reward_points)
      end

      it 'returns nil if there are no streaks' do
        protocol_without_rewards = FactoryBot.create(:protocol)
        protocol_subscription_without_rewards = FactoryBot.create(:protocol_subscription,
                                                                  protocol: protocol_without_rewards)
        current_json = described_class.new(protocol_subscription_without_rewards).as_json.with_indifferent_access
        expect(current_json[:max_streak]).to be_nil
      end
    end

    it 'contains the correct max_still_awardable_euros' do
      expected = protocol_subscription.protocol_completion[-5..]
      expected = protocol.calculate_reward(expected, true)
      expect(json[:max_still_awardable_euros]).to eq expected
    end

    it 'contains the correct euro_delta' do
      remove_indices = (future_responses.length + 1) * -1
      expected = protocol_subscription.protocol_completion[remove_indices]
      expected = protocol.calculate_reward([expected])
      expect(json[:euro_delta]).to eq expected
    end

    describe 'should contain the correct initial multiplier' do
      let(:current_protocol) { FactoryBot.create(:protocol) }

      it 'is 1 if there are no multipliers' do
        current_protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: current_protocol)
        result = described_class.new(current_protocol_subscription).as_json.with_indifferent_access
        expected = 1
        expect(result[:initial_multiplier]).to eq expected
      end

      it 'is the multiplier of the first reward if there are multiple rewards' do
        reward = FactoryBot.create(:reward, threshold: 1, reward_points: 42, protocol: current_protocol)
        FactoryBot.create(:reward, threshold: 2, reward_points: 150, protocol: current_protocol)
        current_protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: current_protocol)
        result = described_class.new(current_protocol_subscription).as_json.with_indifferent_access
        expected = reward.reward_points
        expect(result[:initial_multiplier]).to eq expected
      end
    end

    it 'contains the correct earned_euros' do
      expected = protocol_subscription.protocol_completion
      expected = protocol.calculate_reward(expected) / 100.0
      expect(json[:earned_euros]).to eq expected
    end

    it 'contains the correct questionnaire titles' do
      questionnaire_key = FactoryBot.create(:questionnaire, key: 'my_questionnaire', title: '')
      questionnaire_title = FactoryBot.create(:questionnaire, title: 'Some Questionnaire')
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement, protocol: protocol, questionnaire: questionnaire_key)
      FactoryBot.create(:measurement, protocol: protocol, questionnaire: questionnaire_title)
      protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
      result = described_class.new(protocol_subscription).as_json.with_indifferent_access
      # if the title is blank, the humanized key is returned instead
      expect(result[:questionnaires]).to match_array(['My questionnaire', 'Some Questionnaire'])
    end
  end
end
