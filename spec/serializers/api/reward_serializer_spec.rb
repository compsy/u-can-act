# frozen_string_literal: true

require 'rails_helper'

module Api
  fdescribe RewardSerializer do
    before :each do
      Timecop.freeze(2017, 2, 1)
    end

    let!(:protocol_subscription) { FactoryGirl.create(:protocol_subscription) }
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
      it 'should contain the correct id, reward_points, max_rewardpoints and possible rewardpoints' do
        expect(json[:id]).to eq protocol_subscription.id
        expect(json[:reward_points]).to eq protocol_subscription.reward_points
        expect(json[:max_reward_points]).to eq protocol_subscription.max_reward_points
        expect(json[:possible_reward_points]).to eq protocol_subscription.possible_reward_points
      end

      it 'should contain the list of finished questionnaires' do
        expect(json[:measurement_completion]).to be_an Array
        expect(json[:measurement_completion].max).to be <= ProtocolSubscription::STREAK_POINTS_NEEDED
        expect(json[:measurement_completion].first).to eq 1
        expect(json[:measurement_completion].second).to eq 0
        (2..7).each do |entry|
          expected_value = [entry - 1, ProtocolSubscription::STREAK_POINTS_NEEDED].min
          expect(json[:measurement_completion][entry]).to eq expected_value
        end
        (8..13).each do |entry|
          expected_value = -1
          expect(json[:measurement_completion][entry]).to eq expected_value
        end
      end
    end
  end
end
