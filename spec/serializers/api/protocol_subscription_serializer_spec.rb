# frozen_string_literal: true

require 'rails_helper'

module Api
  describe ProtocolSubscriptionSerializer do
    before :each do
      Timecop.freeze(2017, 2, 1)
    end

    let!(:protocol) { FactoryGirl.create(:protocol, :with_rewards) }
    let!(:protocol_subscription) { FactoryGirl.create(:protocol_subscription, protocol: protocol) }
    let!(:responses) do
      FactoryGirl.create(:response, :completed,
                         protocol_subscription: protocol_subscription, open_from: 8.days.ago.in_time_zone)
      FactoryGirl.create(:response, :invite_sent,
                         protocol_subscription: protocol_subscription, open_from: 7.days.ago.in_time_zone)

      # Streak
      (1..6).each do |day|
        FactoryGirl.create(:response, :completed,
                           protocol_subscription: protocol_subscription, open_from: day.days.ago.in_time_zone)
      end
      (0..5).each do |day|
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription, open_from: day.days.from_now.in_time_zone)
      end
    end

    subject(:json) { described_class.new(protocol_subscription).as_json.with_indifferent_access }

    it 'should have the correct initialization' do
      protocol_subscription.reload
      expect(protocol_subscription.responses.length).to eq(6 + 6 + 2)
    end

    describe 'renders the correct json' do
      it 'should contain the correct variables' do
        # Mock the actual calculation
        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with(protocol_subscription.protocol_completion)
          .and_return(321)

        # Mock the actual calculation
        slice = (8...(8 + protocol_subscription.responses.future.length))
        sliced_completion = protocol_subscription.protocol_completion.slice(slice)
        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with(sliced_completion, true)
          .and_return(123)

        sliced_completion = [protocol_subscription.protocol_completion[6]]
        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with(sliced_completion)
          .and_return(888)
        json = described_class.new(protocol_subscription).as_json.with_indifferent_access

        expect(json[:person_type]).to eq protocol_subscription.person.type
        expect(json[:earned_euros]).to eq 321
        expect(json[:euro_delta]).to eq 888
        expect(json[:max_still_awardable_euros]).to eq 123

        completions_strings = protocol_subscription.protocol_completion.map(&:stringify_keys)
        expect(json[:protocol_completion]).to eq completions_strings
      end

      describe 'max_streak' do
        it 'should contain a hash with the max achievable streak if there is one' do
          expect(json[:max_streak]).to_not be_nil

          expect(json[:max_streak][:threshold]).to_not be_nil
          expect(json[:max_streak][:threshold]).to eq(protocol_subscription.protocol.max_streak.threshold)

          expect(json[:max_streak][:reward_points]).to_not be_nil
          expect(json[:max_streak][:reward_points]).to eq(protocol_subscription.protocol.max_streak.reward_points)
        end

        it 'should return nil if there are no streaks' do
          protocol_without_rewards = FactoryGirl.create(:protocol)
          protocol_subscription_without_rewards = FactoryGirl.create(:protocol_subscription,
                                                                     protocol: protocol_without_rewards)
          current_json = described_class.new(protocol_subscription_without_rewards).as_json.with_indifferent_access
          byebug
          expect(current_json[:max_streak]).to be_nil
        end
      end

      it 'should contain the correct max_still_awardable_euros' do
        json = described_class.new(protocol_subscription).as_json.with_indifferent_access
        expected = protocol_subscription.protocol_completion[-6..-1]
        expected = protocol.calculate_reward(expected, true)
        expect(json[:max_still_awardable_euros]).to eq expected
      end

      it 'should contain the correct euro_delta' do
        expected = protocol_subscription.protocol_completion[-7]
        expected = protocol.calculate_reward([expected])
        expect(json[:euro_delta]).to eq expected
      end

      it 'should contain the correct earned_euros' do
        expected = protocol_subscription.protocol_completion
        expected = protocol.calculate_reward(expected)
        expect(json[:earned_euros]).to eq expected
      end
    end
  end
end
