# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireGenerator do
  let(:responseobj) { FactoryBot.create(:response) }
  describe 'generate_questionnaire' do # This is the only public method
    it 'should generate a questionnaire' do
      result = described_class.generate_questionnaire(responseobj.id,
                                                      responseobj.measurement.questionnaire.content,
                                                      'Dit is een titel {{deze_student}}',
                                                      'Opslaan',
                                                      '/',
                                                      'authenticity-token')
      # We already check the semantics of the questionnaire in the feature test, so just
      # check for the hidden fields here and make sure that we get a form.
      expect(result).to include('authenticity-token')
      expect(result).to include(responseobj.id.to_s)
      expect(result).to include('response_id')
      expect(result).to include('utf8')
      expect(result).to include('authenticity_token')
      expect(result).to include('<form')
      expect(result).to include('Jane')
    end
    it 'should raise an error when given a question of unknown type' do
      questionnaire_content = [{
        section_start: 'Algemeen',
        id: :v1,
        type: :asdf,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }]
      expect do
        described_class.send(:questionnaire_questions,
                             questionnaire_content, nil, questionnaire_content)
      end.to raise_error(RuntimeError, 'Unknown question type asdf')
    end
  end
  describe 'generate_json_questionnaire' do
    before :each do
      questionnaire_content = [{
        section_start: 'Algemeen',
        id: :v1,
        type: :range,
        title: 'Hoe voelt {{deze_student}} zich vandaag?',
        options: %w[slecht goed]
      }]
      @result = described_class.generate_hash_questionnaire(responseobj.id,
                                                            questionnaire_content,
                                                            'Dit is een titel {{deze_student}}')
    end
    it 'should return a hash with the title and content' do
      expect(@result).to be_a Hash
      expect(@result.keys).to match_array %i[title content]
    end

    it 'should provide the content of the questionnaire as a hash' do
      expect(@result[:content]).to be_a Array
      expect(@result[:content].all? { |quest| quest.is_a? Hash }).to be_truthy
    end

    it 'should replace names in the json' do
      expect(@result[:content].first[:title]).to include('Jane')
      expect(@result[:content].first[:title]).to_not include('deze_student')
    end

    it 'should replace names in the title' do
      expect(@result[:title]).to include('Jane')
      expect(@result[:title]).to_not include('deze_student')
    end
  end
end
