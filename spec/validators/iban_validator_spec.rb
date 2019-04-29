# frozen_string_literal: true

require 'rails_helper'

describe IbanValidator do
  let(:person) { FactoryBot.create(:person) }

  it 'should return errors if the iban is incorrect' do
    incorrect_ibans = [
      '0812341234',
      'NL36RABO 0123412341',
      'RABO0123412341',
      '0123412341',
      '123412341',
      'NLRABO0123412341',
      'NL36RABO0111111111'
    ]
    incorrect_ibans.each do |incorrect_iban|
      person.iban = incorrect_iban
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :iban
      expect(person.errors.messages[:iban]).to include('is ongeldig')
    end
  end

  describe 'with a correct iban' do
    it 'should not return errors' do
      person.iban = 'NL91ABNA0417164300'
      expect(person).to be_valid
    end
    it 'should not return errors with spaces in the iban' do
      person.iban = 'NL 91 ABNA 0 4171 64 300'
      expect(person).to be_valid
    end
  end

  it 'should not return errors if the iban is nil' do
    person.iban = nil
    expect(person).to be_valid
  end
end
