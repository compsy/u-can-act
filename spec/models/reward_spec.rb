# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    it 'should have valid default properties' do
      reward = FactoryBot.build(:reward)
      expect(reward.valid?).to be_truthy
    end

    describe 'threshold' do
      it 'should be integer' do
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 2.1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be positive' do
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: -1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 0)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be unique within a protocol' do
        protocol = FactoryBot.create(:protocol)
        different_protocol = FactoryBot.build(:protocol)
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
        reward = FactoryBot.build(:reward, protocol: protocol, reward_points: 100, threshold: 1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, protocol: different_protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be able to create multiple rewards for one protocol' do
        protocol = FactoryBot.create(:protocol)
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
        reward = FactoryBot.create(:reward, protocol: protocol, reward_points: 100, threshold: 2)
        expect(reward).to be_valid
        expect(protocol.rewards.length).to eq 2
      end
    end

    describe 'protocol' do
      it 'should be present' do
        reward = FactoryBot.build(:reward, protocol: nil)
        protocol = FactoryBot.build(:protocol)
        expect(reward).to_not be_valid
        reward.protocol = protocol
        expect(reward).to be_valid
      end
    end

    describe 'reward_points' do
      it 'should be integer' do
        reward = FactoryBot.build(:reward, reward_points: 5.1, threshold: 1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be positive' do
        reward = FactoryBot.build(:reward, reward_points: -100, threshold: 1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 0, threshold: 1)
        expect(reward).to_not be_valid
        reward = FactoryBot.build(:reward, reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end
    end
  end
end
