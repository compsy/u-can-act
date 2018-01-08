# frozen_string_literal: true

require 'rails_helper'

describe InvitationTexts do
  describe 'message' do
    it 'should raise an error' do
      expect do
        described_class.message(1, 2)
      end.to raise_error(RuntimeError, 'method message not implemented by subclass!')
    end
  end
  describe 'first_response_pool' do
    it 'should raise an error' do
      expect do
        described_class.first_response_pool
      end.to raise_error(RuntimeError, 'method first_response_pool not implemented by subclass!')
    end
  end
  describe 'second_response_pool' do
    it 'should raise an error' do
      expect do
        described_class.second_response_pool
      end.to raise_error(RuntimeError, 'method second_response_pool not implemented by subclass!')
    end
  end
  describe 'rewards_threshold_pool' do
    it 'should raise an error' do
      expect do
        described_class.rewards_threshold_pool(1)
      end.to raise_error(RuntimeError, 'method rewards_threshold_pool not implemented by subclass!')
    end
  end
  describe 'default_pool' do
    it 'should raise an error' do
      expect do
        described_class.default_pool(nil)
      end.to raise_error(RuntimeError, 'method default_pool not implemented by subclass!')
    end
  end
  describe 'about_to_be_on_streak_pool' do
    it 'should raise an error' do
      expect do
        described_class.about_to_be_on_streak_pool
      end.to raise_error(RuntimeError, 'method about_to_be_on_streak_pool not implemented by subclass!')
    end
  end
  describe 'on_streak_pool' do
    it 'should raise an error' do
      expect do
        described_class.on_streak_pool
      end.to raise_error(RuntimeError, 'method on_streak_pool not implemented by subclass!')
    end
  end
  describe 'first_responses_missed_pool' do
    it 'should raise an error' do
      expect do
        described_class.first_responses_missed_pool
      end.to raise_error(RuntimeError, 'method first_responses_missed_pool not implemented by subclass!')
    end
  end
  describe 'missed_last_pool' do
    it 'should raise an error' do
      expect do
        described_class.missed_last_pool
      end.to raise_error(RuntimeError, 'method missed_last_pool not implemented by subclass!')
    end
  end
  describe 'missed_more_than_one_pool' do
    it 'should raise an error' do
      expect do
        described_class.missed_more_than_one_pool
      end.to raise_error(RuntimeError, 'method missed_more_than_one_pool not implemented by subclass!')
    end
  end
  describe 'missed_everything_pool' do
    it 'should raise an error' do
      expect do
        described_class.missed_everything_pool
      end.to raise_error(RuntimeError, 'method missed_everything_pool not implemented by subclass!')
    end
  end
  describe 'rejoined_after_missing_one_pool' do
    it 'should raise an error' do
      expect do
        described_class.rejoined_after_missing_one_pool
      end.to raise_error(RuntimeError, 'method rejoined_after_missing_one_pool not implemented by subclass!')
    end
  end
  describe 'rejoined_after_missing_multiple_pool' do
    it 'should raise an error' do
      expect do
        described_class.rejoined_after_missing_multiple_pool
      end.to raise_error(RuntimeError, 'method rejoined_after_missing_multiple_pool not implemented by subclass!')
    end
  end
end
