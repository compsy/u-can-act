# frozen_string_literal: true

require 'rails_helper'

describe RandomAlphaNumericStringGenerator do
  describe 'self.generate' do
    it 'should return an empty string if the length == 0' do
      result = described_class.generate(0)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'should return an empty string if the length < 0' do
      result = described_class.generate(-1)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'should return a string with the correct length' do
      (1..10).each do |x|
        result = described_class.generate(x)
        expect(result.length).to eq x
      end
    end

    it 'should only generate alpha numerical strings' do
      (1..10).each do |x|
        result = described_class.generate(x)
        expect(result).to match(/\A[a-z0-9]{#{x}}\z/i)
      end
    end
  end
end
