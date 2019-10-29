# frozen_string_literal: true

require 'rails_helper'

describe MobilePhoneValidator do
  class Validatable
    include ActiveModel::Validations
    validates :mobile_phone, mobile_phone: true
    attr_accessor :mobile_phone
  end

  let(:record) { Validatable.new }

  it 'returns errors if the number does not start with a recognized prependation' do
    record.mobile_phone = '0812341234'
    expect(record).not_to be_valid
    expect(record.errors.messages).to have_key :mobile_phone
    expect(record.errors.messages[:mobile_phone]).to include('mag alleen een Nederlands nummer zijn')
  end

  it 'does not return errors if the number is correct and dutch' do
    record.mobile_phone = '0612341234'
    expect(record).to be_valid
  end
end
