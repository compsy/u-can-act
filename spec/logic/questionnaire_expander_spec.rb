# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireExpander do
  let(:response) { FactoryBot.create(:response) }
  describe 'expand_content' do
    it 'should call the variable substitutor for a title and return an array' do
      content = 'Hoi {{deze_student}} {{hij_zij_student}} {{naam_begeleider}} {{hem_haar_begeleider}}'
      mockresult = 'the result'
      expect(VariableSubstitutor).to receive(:substitute_variables).with(response).and_return({})
      expect(VariableEvaluator).to receive(:evaluate_obj).with(content, {}).and_return mockresult
      result = described_class.expand_content(content, response)
      expect(result).to eq [mockresult]
    end

    it 'should not give an error if the response is nil' do
      # the nil response is used in the admin preview
      content = { id: :v2,
                  type: :checkbox,
                  title: 'Wat heeft u vandaag gegeten?',
                  foreach: :student,
                  options: [
                    { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                    { title: 'kaas en ham' },
                    { title: 'pizza' }
                  ] }
      result = described_class.expand_content(content, nil)
      expect(result).to eq [content]
    end

    it 'should call the variable substitutor for a regular question and return an array' do
      content = { id: :v2,
                  type: :checkbox,
                  title: 'Wat heeft u vandaag gegeten?',
                  options: [
                    { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                    { title: 'kaas en ham' },
                    { title: 'pizza' }
                  ] }

      expect(VariableSubstitutor).to receive(:substitute_variables).with(response).and_return({})
      expect(VariableEvaluator).to receive(:evaluate_obj).with(content, {}).and_return content
      result = described_class.expand_content(content, response)
      expect(result).to eq [content]
    end

    it 'should raise if the provided foreach is not defined' do
      content = { id: :v2,
                  type: :checkbox,
                  foreach: :mentor,
                  title: 'Wat heeft u vandaag gegeten?',
                  options: [
                    { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                    { title: 'kaas en ham' },
                    { title: 'pizza' }
                  ] }
      expect { described_class.expand_content(content, response) }
        .to raise_error(RuntimeError, 'Only :student foreach type is allowed, not mentor')
    end
    it 'should call the variable substitutor multiple times for a foreach question' do
      team = FactoryBot.create(:team)
      student_role = FactoryBot.create(:role, team: team, group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, team: team, group: Person::MENTOR, title: 'MentorTitle')
      students = FactoryBot.create_list(:student, 10, role: student_role, first_name: 'Emma', gender: Person::FEMALE)
      mentor = FactoryBot.create(:mentor, role: mentor_role, first_name: 'Pieter', gender: Person::MALE)
      prot_ment = nil
      students.each do |student|
        prot_ment = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      end

      responseobj = FactoryBot.create(:response, protocol_subscription: prot_ment)

      content = { id: :v2,
                  type: :checkbox,
                  title: 'Wat heeft u vandaag gegeten?',
                  foreach: :student,
                  options: [
                    { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                    { title: 'kaas en ham' },
                    { title: 'pizza' }
                  ] }

      expected = students.map do |student|
        expect(VariableSubstitutor).to receive(:create_substitution_hash).with(mentor, student).and_return({})
        content_dup = content.deep_dup
        content_dup[:id] = "#{content_dup[:id]}_#{student.external_identifier}"
        expect(VariableEvaluator).to receive(:evaluate_obj).with(content_dup, {}).and_return content_dup
        content_dup
      end
      result = described_class.expand_content(content, responseobj)
      expect(result).to match_array expected
    end
  end
end
