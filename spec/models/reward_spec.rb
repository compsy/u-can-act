# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    describe 'threshold' do
      it 'should be integer' do
        reward = Reward.new(reward_points: 100, threshold: 2.1)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be positive' do
        reward = Reward.new(reward_points: 100, threshold: -1)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 100, threshold: 0)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end
    end

    describe 'reward_points' do
      it 'should be integer' do
        reward = Reward.new(reward_points: 5.1, threshold: 1)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end

      it 'should be positive' do
        reward = Reward.new(reward_points: -100, threshold: 1)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 0, threshold: 1)
        expect(reward).to_not be_valid
        reward = Reward.new(reward_points: 100, threshold: 1)
        expect(reward).to be_valid
      end
    end
  end
end
