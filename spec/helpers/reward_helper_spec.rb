# frozen_string_literal: true

require 'rails_helper'

describe RewardHelper, focus: true do
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
end
