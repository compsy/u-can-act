# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    it 'has valid default properties' do
      reward = FactoryBot.create(:reward)
      expect(reward).to be_valid
    end

    describe 'threshold' do
      it 'is integer' do
        reward = FactoryBot.create(:reward)
        reward.reward_points = 100
        reward.threshold = 2.1
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'is positive' do
        reward = FactoryBot.create(:reward)
        reward.reward_points = 100
        reward.threshold = -1
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100)
        reward.threshold = 0
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'is unique within a protocol' do
        protocol = FactoryBot.create(:protocol)
        different_protocol = FactoryBot.create(:protocol)
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100, threshold: 1)
        reward.protocol = protocol
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, protocol: different_protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'is able to create multiple rewards for one protocol' do
        protocol = FactoryBot.create(:protocol)
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 2)
        expect(reward).to be_valid
        expect(protocol.rewards.length).to eq 2
      end
    end

    describe 'protocol' do
      it 'is present' do
        reward = FactoryBot.create(:reward)
        reward.protocol = nil
        protocol = FactoryBot.create(:protocol)
        expect(reward).not_to be_valid
        reward.protocol = protocol
        expect(reward).to be_valid
      end
    end

    describe 'reward_points' do
      it 'is integer' do
        reward = FactoryBot.create(:reward, threshold: 1)
        reward.reward_points = 5.1
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'is positive' do
        reward = FactoryBot.create(:reward, threshold: 1)
        reward.reward_points = -100
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, threshold: 1)
        reward.reward_points = 0
        expect(reward).not_to be_valid
        reward = FactoryBot.create(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end
    end

    describe 'max_still_earnable_euros' do
      it 'works with one person' do
        protocol = FactoryBot.create(:protocol)
        FactoryBot.create(:measurement, protocol: protocol, open_from_offset: (1.day + 11.hours).to_i)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol.rewards.create!(threshold: 1, reward_points: 2)
        protocol.rewards.create!(threshold: 3, reward_points: 3)
        FactoryBot.create(:protocol_subscription,
                          protocol: protocol,
                          start_date: Time.zone.now.beginning_of_day)
        expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 0.08
      end
      it 'works with multiple people' do
        protocol = FactoryBot.create(:protocol)
        FactoryBot.create(:measurement, protocol: protocol, open_from_offset: (1.day + 11.hours).to_i)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol.rewards.create!(threshold: 1, reward_points: 2)
        protocol.rewards.create!(threshold: 3, reward_points: 3)
        FactoryBot.create(:protocol_subscription,
                          protocol: protocol,
                          start_date: Time.zone.now.beginning_of_day)
        FactoryBot.create(:protocol_subscription,
                          protocol: protocol,
                          start_date: Time.zone.now.beginning_of_day)
        expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 0.16
      end
    end

    describe 'total_earned_euros' do
      it 'works with one person' do
        protocol = FactoryBot.create(:protocol)
        FactoryBot.create(:measurement, protocol: protocol, open_from_offset: 0)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol.rewards.create!(threshold: 1, reward_points: 2)
        protocol.rewards.create!(threshold: 3, reward_points: 3)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  start_date: Time.zone.now.beginning_of_day)
        protocol_subscription.responses.first.complete!
        Timecop.freeze(1.week.from_now) do
          expect(Reward.total_earned_euros(bust_cache: true)).to eq 0.02
        end
      end
      it 'works with multiple people' do
        protocol = FactoryBot.create(:protocol)
        FactoryBot.create(:measurement, protocol: protocol, open_from_offset: (1.day + 11.hours).to_i)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol.rewards.create!(threshold: 1, reward_points: 2)
        protocol.rewards.create!(threshold: 3, reward_points: 3)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  start_date: 1.week.ago.beginning_of_day)
        protocol_subscription.responses.first.complete!
        protocol_subscription2 = FactoryBot.create(:protocol_subscription,
                                                   protocol: protocol,
                                                   start_date: 1.week.ago.beginning_of_day)
        protocol_subscription2.responses.first.complete!
        Timecop.freeze(1.week.from_now) do
          expect(Reward.total_earned_euros(bust_cache: true)).to eq 0.04
        end
      end
    end
  end
end
