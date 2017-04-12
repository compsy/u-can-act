# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a person object' do
  describe 'inheritance' do
    it 'should be a Person' do
      expect(subject).to be_a Person
    end
  end

  it 'should have valid default properties' do
    person = FactoryGirl.build(:person)
    expect(person.valid?).to be_truthy
  end

  describe 'mobile_phone' do
    let(:person) { FactoryGirl.create(:person) }

    it 'should not accept an empty number' do
      person.mobile_phone = ''
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te kort (minimaal 10 tekens)')
    end

    it 'should not accept nil as a number' do
      person.mobile_phone = nil
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is ongeldig')
    end

    it 'should not accept numbers that are not length 10' do
      person.mobile_phone = '061234567'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te kort (minimaal 10 tekens)')
      person.mobile_phone = '06123456789'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te lang (maximaal 10 tekens)')
    end

    it 'should not accept numbers that do not start with 06' do
      person.mobile_phone = '0112345678'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('mag alleen een Nederlands nummer zijn')
    end
  end
end
