# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireExpander do
  let(:response) { FactoryBot.create(:response) }

  describe 'expand_content' do
    it 'calls the variable substitutor for a title and return an array' do
      content = 'Hoi {{deze_student}} {{hij_zij_student}} {{naam_begeleider}} {{hem_haar_begeleider}}'
      mockresult = 'the result'
      expect(VariableSubstitutor).to receive(:substitute_variables).with(response).and_return({})
      expect(VariableEvaluator).to receive(:evaluate_obj).with(content, {}).and_return mockresult
      result = described_class.expand_content(content, response)
      expect(result).to eq [mockresult]
    end

    it 'calls the variable substitutor for a regular question and return an array' do
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

    describe 'first_response' do
      let(:other_response) { FactoryBot.create(:response) }

      describe 'titles' do
        let(:content) do
          { id: :v2,
            type: :checkbox,
            title: {
              normal: 'Wat heeft u vandaag gegeten?',
              first: 'Heeft u ooit gegeten?'
            },
            options: [
              { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
              { title: 'kaas en ham' },
              { title: 'pizza' }
            ] }
        end

        it 'replaces the title with the first response title if this is the first response' do
          expect(PreviousResponseFinder).to receive(:find)
            .with(response)
            .and_return(nil)

          result = described_class.expand_content(content.dup, response)
          expect(result.first[:title]).to eq(content[:title][:first])
          content[:title] = content[:title][:first]
          expect(result).to eq([content])
        end

        it 'does not replace the title if the current response is not the first response' do
          expect(PreviousResponseFinder).to receive(:find)
            .with(response)
            .and_return(other_response)

          result = described_class.expand_content(content.dup, response)
          expect(result.first[:title]).to eq(content[:title][:normal])
          content[:title] = content[:title][:normal]
          expect(result).to eq([content])
        end
      end

      describe 'content' do
        let(:content) do
          { type: :raw,
            content: {
              normal: 'Wat heeft u vandaag gegeten?',
              first: 'Heeft u ooit gegeten?'
            } }
        end

        it 'does not replace the content if the current response is not the first response' do
          allow(PreviousResponseFinder).to receive(:find)
            .with(response)
            .and_return(other_response)

          result = described_class.expand_content(content.dup, response)
          expect(result.first[:content]).to eq(content[:content][:normal])
          content[:content] = content[:content][:normal]
          expect(result).to eq([content])
        end

        it 'replaces the content with the first response content if this is the first response' do
          allow(PreviousResponseFinder).to receive(:find)
            .with(response)
            .and_return(nil)

          result = described_class.expand_content(content.dup, response)
          expect(result.first[:content]).to eq(content[:content][:first])
          content[:content] = content[:content][:first]
          expect(result).to eq([content])
        end
      end
    end

    describe 'foreach' do
      it 'raises if the provided foreach is not defined' do
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

      it 'calls the variable substitutor multiple times for a foreach question' do
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

    describe 'uses' do
      it 'raises if the provided uses is not defined' do
        content = { id: :v2,
                    type: :checkbox,
                    uses: :mentor,
                    title: 'Wat heeft u vandaag gegeten?',
                    options: [
                      { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                      { title: 'kaas en ham' },
                      { title: 'pizza' }
                    ] }
        expect { described_class.expand_content(content, response) }
          .to raise_error(RuntimeError, "Uses must be of hash type type, not 'mentor'")
      end

      it 'raises if the provided uses is not defined' do
        content = { id: :v2,
                    type: :checkbox,
                    uses: { mentor: 'abc' },
                    title: 'Wat heeft u vandaag gegeten?',
                    options: [
                      { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                      { title: 'kaas en ham' },
                      { title: 'pizza' }
                    ] }
        expect { described_class.expand_content(content, response) }
          .to raise_error(RuntimeError, "Only :previous uses type is allowed, not '{:mentor=>\"abc\"}'")
      end

      it 'returns an array' do
        content = { id: :v2,
                    type: :checkbox,
                    uses: { previous: :v2 },
                    title: 'Wat heeft u vandaag gegeten?',
                    options: [
                      { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                      { title: 'kaas en ham' },
                      { title: 'pizza' }
                    ] }

        result = described_class.expand_content(content, response)
        expect(result).to be_an Array
      end

      it 'calls the correct external functions with the right parameters' do
        other_response = FactoryBot.create(:response)
        result = { the: 'hash' }
        expected = 'the expected result'
        content = { id: :v2,
                    type: :checkbox,
                    uses: { previous: :v2 },
                    title: 'Wat heeft u vandaag gegeten?',
                    options: [
                      { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                      { title: 'kaas en ham' },
                      { title: 'pizza' }
                    ] }

        expect(PreviousResponseFinder).to receive(:find_value)
          .with(response, :v2)
          .and_return(other_response)

        expect(VariableSubstitutor).to receive(:substitute_variables)
          .with(response)
          .and_return(result)

        expect(VariableEvaluator).to receive(:evaluate_obj)
          .with(content, result)
          .and_return(expected)

        result = described_class.expand_content(content, response)
        expect(result).to eq([expected])
      end

      it 'calls the correct external functions with the right parameters and default value' do
        result = { the: 'hash' }
        expected = 'the expected result'
        default = 'hallo!'
        content = { id: :v2,
                    type: :checkbox,
                    uses: { previous: :v2, default: default },
                    title: 'Wat heeft u vandaag gegeten?',
                    options: [
                      { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                      { title: 'kaas en ham' },
                      { title: 'pizza' }
                    ] }

        expect(PreviousResponseFinder).to receive(:find_value)
          .with(response, :v2)

        expect(VariableSubstitutor).to receive(:substitute_variables)
          .with(response)
          .and_return(result)

        expect(VariableEvaluator).to receive(:evaluate_obj)
          .with(content, result)
          .and_return(expected)

        result = described_class.expand_content(content, response)
        expect(result).to eq([expected])
      end
    end
  end
end
