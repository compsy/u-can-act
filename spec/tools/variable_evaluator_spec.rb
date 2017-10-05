# frozen_string_literal: true

require 'rails_helper'

describe VariableEvaluator do
  describe 'evaluate' do
    let(:mentor_title) { 'stamhoofd' }
    let(:mentor_sex) { 'female' }
    let(:student_name) { 'William Sealy Gosset' }
    let(:student_sex) { 'male' }
    it 'should replace all the words correctly' do
      given = 'Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}} en '\
              '{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad? '\
              '{{hij_zij_student}} al wel.'
      expected = 'Heeft je stamhoofd al haar vragenlijsten ingevuld voor William Sealy Gosset en zijn vrienden? '\
                 'Of heeft zij daar nog geen tijd voor gehad? hij al wel.'
      expect(described_class.evaluate(given, mentor_title, mentor_sex, student_name, student_sex)).to eq expected
    end
    it 'should work with capitalization' do
      given = 'Heeft je {{Begeleider}} al {{Zijn_haar_begeleider}} vragenlijsten ingevuld voor {{Deze_student}} en '\
              '{{Zijn_haar_student}} vrienden? Of heeft {{Hij_zij_begeleider}} daar nog geen tijd voor gehad? '\
              '{{Hij_zij_student}} al wel.'
      expected = 'Heeft je Stamhoofd al Haar vragenlijsten ingevuld voor William Sealy Gosset en Zijn vrienden? '\
                 'Of heeft Zij daar nog geen tijd voor gehad? Hij al wel.'
      expect(described_class.evaluate(given, mentor_title, mentor_sex, student_name, student_sex)).to eq expected
    end
    it 'should replace with default values when values are missing' do
      given = 'Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}} en '\
              '{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad? '\
              '{{Hij_zij_student}} al wel.'
      expected = 'Heeft je begeleider al zijn/haar vragenlijsten ingevuld voor deze student en zijn/haar vrienden? '\
                 'Of heeft hij/zij daar nog geen tijd voor gehad? Hij/zij al wel.'
      expect(described_class.evaluate(given)).to eq expected
    end
    it 'should not make any changes when there are no variables' do
      given = 'Dit is een tekst {{zonder}} variabelen.'
      expected = given
      expect(described_class.evaluate(given, mentor_title, mentor_sex, student_name, student_sex)).to eq expected
    end
  end
end
