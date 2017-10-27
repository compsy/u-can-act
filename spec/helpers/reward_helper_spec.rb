# frozen_string_literal: true

require 'rails_helper'

describe RewardHelper do
  describe 'as_percentage' do
    it 'should return the percentage of two numbers' do
      result = helper.as_percentage(2, 5)
      expect(result).to eq '40'
    end
    it 'should work with fractions' do
      result = helper.as_percentage(1, 3)
      expect(result).to eq '33'
    end
    it 'should handling rounding correctly' do
      result = helper.as_percentage(2, 3)
      expect(result).to eq '67'
    end
    it 'should given an error when dividing by zero' do
      expect { helper.as_percentage(1, 0) }.to raise_error(FloatDomainError)
    end
  end

  describe 'mentor?' do
    it 'should return true when the person is a Mentor' do
      person = FactoryGirl.build(:mentor)
      protocol_subscription = double('protocol_subscription')
      expect(protocol_subscription).to receive(:person).and_return(person)
      helper.instance_variable_set(:@protocol_subscription, protocol_subscription)
      expect(helper.mentor?).to be_truthy
    end
    it 'should return false when the person is a Student' do
      person = FactoryGirl.build(:student)
      protocol_subscription = double('protocol_subscription')
      expect(protocol_subscription).to receive(:person).and_return(person)
      helper.instance_variable_set(:@protocol_subscription, protocol_subscription)
      expect(helper.mentor?).to be_falsey
    end
  end
end
