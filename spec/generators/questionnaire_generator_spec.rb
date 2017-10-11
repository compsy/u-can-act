# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireGenerator do
  describe 'generate_questionnaire' do # This is the only public method
    it 'should generate a questionnaire' do
      responseobj = FactoryGirl.create(:response)
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
                             questionnaire_content)
      end.to raise_error(RuntimeError, 'Unknown question type')
    end
  end
end
