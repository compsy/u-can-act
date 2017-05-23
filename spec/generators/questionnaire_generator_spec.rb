# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireGenerator do
  describe 'generate_questionnaire' do # This is the only public method
    it 'should generate a questionnaire' do
      responseobj = FactoryGirl.create(:response)
      result = described_class.generate_questionnaire(responseobj, 'authenticity-token')
      # We already check the semantics of the questionnaire in the feature test, so just
      # check for the hidden fields here and make sure that we get a form.
      expect(result).to include('authenticity-token')
      expect(result).to include(responseobj.id.to_s)
      expect(result).to include('response_id')
      expect(result).to include('utf8')
      expect(result).to include('authenticity_token')
      expect(result).to include('<form')
    end
  end
end
