# frozen_string_literal: true

require 'rails_helper'

describe Exporters do
  describe 'test_phone_number?' do
    it 'should check if the phone number is listed in the env var when there is one phone number in ENV' do
      ENV['TEST_PHONE_NUMBERS'] = '0612341234'
      result = described_class.test_phone_number?('0612341234')
      expect(result).to be_truthy
    end

    it 'should check if the phone number is listed in the env var when there there are multiple phone number in ENV' do
      ENV['TEST_PHONE_NUMBERS'] = '06120389123,0612341234,0688996677'
      result = described_class.test_phone_number?('0612341234')
      expect(result).to be_truthy
    end

    it 'should return false if the provided number is not a test number' do
      ENV['TEST_PHONE_NUMBERS'] = '06120389123,0612341234,0688996677'
      result = described_class.test_phone_number?('0611111111')
      expect(result).to be_falsey
    end

    it 'should return false if there is no env var ' do
      ENV['TEST_PHONE_NUMBERS'] = ''
      result = described_class.test_phone_number?('0612341234')
      expect(result).to be_falsey
    end
  end
end
