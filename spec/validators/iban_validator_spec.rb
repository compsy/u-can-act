# frozen_string_literal: true

require 'rails_helper'

describe IbanValidator do
  class Validatable
    include ActiveModel::Validations
    validates_with IbanValidator
    attr_accessor :iban
  end

  let(:record) { Validatable.new }
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
      record.iban = incorrect_iban
      expect(record).not_to be_valid
      expect(record.errors.messages).to have_key :iban
      expect(record.errors.messages[:iban]).to include('is ongeldig')
    end
  end

  describe 'with a correct iban' do
    it 'should not return errors' do
      record.iban = 'NL91ABNA0417164300'
      expect(record).to be_valid
    end
    it 'should not return errors with spaces in the iban' do
      record.iban = 'NL 91 ABNA 0 4171 64 300'
      expect(record).to be_valid
    end
  end

  it 'should not return errors if the iban is nil' do
    record.iban = nil
    expect(record).to be_valid
  end
end
