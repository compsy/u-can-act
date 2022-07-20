# frozen_string_literal: true

require 'rails_helper'

describe VariableEvaluator do
  let(:mentor_title) { 'stamhoofd' }
  let(:mentor_gender) { 'female' }
  let(:mentor_name) { 'Elsa' }
  let(:mentor_last_name) { 'Minnertsma' }
  let(:organization) { 'De Hondsrug' }
  let(:student_name) { 'William Sealy' }
  let(:student_last_name) { 'Gosset' }
  let(:student_gender) { 'male' }
  let(:subs_hash) do
    {
      mentor_title: mentor_title,
      mentor_gender: mentor_gender,
      mentor_name: mentor_name,
      mentor_last_name: mentor_last_name,
      organization: organization,
      student_name: student_name,
      student_last_name: student_last_name,
      student_gender: student_gender
    }
  end

  describe 'evaluate_obj' do
    it 'works with a string' do
      given = '{{begeleider}}'
      expected = mentor_title
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'works with an array' do
      given = ['{{begeleider}}', 'hoi {{deze_student}} {{achternaam_student}}']
      expected = ['stamhoofd', 'hoi William Sealy Gosset']
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'works with the values of a hash' do
      given = { something: '{{begeleider}}', other: 'hallo {{deze_student}} {{achternaam_student}}' }
      expected = { something: 'stamhoofd', other: 'hallo William Sealy Gosset' }
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'does not change other values' do
      given = { a: %w[hallo doei] }
      expected = given
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'works with arbitrarily nested data structures' do
      given = [{ section_start: 'Hoi {{begeleider}}',
                 options: [['one', 'two', '{{deze_student}}']] },
               '{{zijn_haar_begeleider}}']
      expected = [{ section_start: 'Hoi stamhoofd',
                    options: [['one', 'two', 'William Sealy']] },
                  'haar']
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'replaces all the words correctly' do
      given = 'Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}}::' \
              '{{achternaam_student}} en ' \
              '{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad? ' \
              '{{hij_zij_student}} al wel voor {{hem_haar_student}}.'
      expected = 'Heeft je stamhoofd al haar vragenlijsten ingevuld voor William Sealy::Gosset en zijn vrienden? ' \
                 'Of heeft zij daar nog geen tijd voor gehad? hij al wel voor hem.'
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'works with capitalization' do
      given = 'Heeft je {{Begeleider}} al {{Zijn_haar_begeleider}} vragenlijsten ingevuld voor {{Deze_student}} en ' \
              '{{Zijn_haar_student}} vrienden? Of heeft {{Hij_zij_begeleider}} daar nog geen tijd voor gehad? ' \
              '{{Hij_zij_student}} al wel. {{Je_begeleidingsinitiatief}} en {{naam_begeleider}}::' \
              '{{achternaam_begeleider}}.'
      expected = 'Heeft je Stamhoofd al Haar vragenlijsten ingevuld voor William Sealy en Zijn vrienden? ' \
                 'Of heeft Zij daar nog geen tijd voor gehad? Hij al wel. De Hondsrug en Elsa::Minnertsma.'
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end
    it 'replaces with default values when values are missing' do
      given = 'Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}} ' \
              '{{achternaam_student}} en ' \
              '{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad? ' \
              '{{Hij_zij_student}} al wel. {{Je_begeleidingsinitiatief}} en {{naam_begeleider}} ' \
              '{{achternaam_begeleider}}.'
      expected = 'Heeft je begeleider al zijn/haar vragenlijsten ingevuld voor deze student  en zijn/haar vrienden? ' \
                 'Of heeft hij/zij daar nog geen tijd voor gehad? Hij/zij al wel. Je begeleidingsinitiatief ' \
                 'en je begeleider .'
      expect(described_class.evaluate_obj(given, {})).to eq expected
    end
    it 'does not make any changes when there are no variables' do
      given = 'Dit is een tekst {{zonder}} variabelen.'
      expected = given
      expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
    end

    context 'dates' do
      it 'works with a long date format' do
        Timecop.freeze(2018, 11, 2) do
          given = 'Dit is een tekst {{datum_lang}} variabelen.'
          expected = 'Dit is een tekst  2 november 2018 variabelen.'
          expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
        end
      end
      it 'works with a regular date format' do
        Timecop.freeze(2018, 11, 2) do
          given = 'Dit is een tekst {{datum}} variabelen.'
          expected = 'Dit is een tekst 02-11-2018 variabelen.'
          expect(described_class.evaluate_obj(given, subs_hash)).to eq expected
        end
      end
    end
  end
end
