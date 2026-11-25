# frozen_string_literal: true

require 'rails_helper'

describe MobilePhoneValidator do
  class Validatable
    include ActiveModel::Validations

    validates :mobile_phone, mobile_phone: true
    attr_accessor :mobile_phone
  end

  let(:record) { Validatable.new }

  valid_numbers = [
    '0612341234', '06 12341234', '06-12341234',
    '+31612341234', '31612341234', '+31 6 1234 1234',
    '+32470123456', '32470123456', '+32 470 12 34 56', '+32456123456', '+32499123456', '+32412345678'
  ]
  invalid_numbers = [
    '0812341234', '061234123', '06123412345', # Dutch, wrong prefix or length
    '+31201234567', '+3161234123', # Dutch landline, too short
    '0031612341234', '0032470123456', # 00 instead of +
    '0470123456', # Belgian, national format
    '+3221234567', '+3247012345', '+324701234567', # Belgian landline, wrong length
    '+491701234567', '+358401234567', '+12025550123', # other countries
    '+31612341234+', "06\t12341234", 'abc'
  ]

  valid_numbers.each do |number|
    it "accepts #{number}" do
      record.mobile_phone = number
      expect(record).to be_valid
    end
  end

  invalid_numbers.each do |number|
    it "rejects #{number}" do
      record.mobile_phone = number
      expect(record).not_to be_valid
      expect(record.errors.messages[:mobile_phone])
        .to include('mag alleen een Nederlands (06 of +316) of Belgisch (+324) mobiel nummer zijn')
    end
  end

  it 'accepts blank numbers' do
    [nil, ''].each do |number|
      record.mobile_phone = number
      expect(record).to be_valid
    end
  end

  it 'uses the locale for the message' do
    record.mobile_phone = '+491701234567'
    I18n.with_locale(:en) { record.valid? }
    expect(record.errors.messages[:mobile_phone])
      .to eq ['can only be a Dutch (06 or +316) or Belgian (+324) mobile number']
  end

  describe '.allowed?' do
    it 'ignores spaces and hyphens' do
      expect(described_class.allowed?(' +32-470 12 34 56 ')).to be true
    end

    it 'does not accept nil' do
      expect(described_class.allowed?(nil)).to be false
    end
  end
end
