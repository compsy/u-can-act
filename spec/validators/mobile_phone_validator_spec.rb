# frozen_string_literal: true

require 'rails_helper'

describe MobilePhoneValidator do
  let(:student) { FactoryGirl.build(:student) }

  it 'should return errors if the number does not start with a recognized prependation' do
    student.mobile_phone = '0812341234'
    expect(student).not_to be_valid
    expect(student.errors.messages).to have_key :mobile_phone
    expect(student.errors.messages[:mobile_phone]).to include('mag alleen een Nederlands nummer zijn')
  end

  it 'should not return errors if the number is correct and dutch' do
    student.mobile_phone = '0612341234'
    expect(student).to be_valid
  end
end
