# frozen_string_literal: true

require 'rails_helper'

describe RandomStringGenerator do
  describe 'generate_alpha_numeric' do
    it 'returns an empty string if the length == 0' do
      result = described_class.generate_alpha_numeric(0)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'returns an empty string if the length < 0' do
      result = described_class.generate_alpha_numeric(-1)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'returns a string with the correct length' do
      (1..10).each do |x|
        result = described_class.generate_alpha_numeric(x)
        expect(result.length).to eq x
      end
    end

    it 'only generates alpha numerical strings' do
      (1..10).each do |x|
        result = described_class.generate_alpha_numeric(x)
        expect(result).to match(/\A[a-z0-9]{#{x}}\z/i)
      end
    end
  end
  describe 'generate_alphabetical' do
    it 'returns an empty string if the length == 0' do
      result = described_class.generate_alphabetical(0)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'returns an empty string if the length < 0' do
      result = described_class.generate_alphabetical(-1)
      expect(result).to be_blank
      expect(result).to eq ''
    end

    it 'returns a string with the correct length' do
      (1..10).each do |x|
        result = described_class.generate_alphabetical(x)
        expect(result.length).to eq x
      end
    end

    it 'only generates alphabetical strings' do
      (1..10).each do |x|
        result = described_class.generate_alphabetical(x)
        expect(result).to match(/\A[a-z]{#{x}}\z/i)
      end
    end
  end
end
