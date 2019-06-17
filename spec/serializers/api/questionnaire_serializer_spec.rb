# frozen_string_literal: true

require 'rails_helper'

describe Api::QuestionnaireSerializer do
  subject(:json) { described_class.new(questionnaire).as_json.with_indifferent_access }

  let!(:questionnaire) { FactoryBot.create(:questionnaire) }

  describe 'renders the correct json' do
    it 'contains the correct variables' do
      expect(json).not_to be_nil
      expect(json.keys).to eq(%w[title key name content])
      expect(json[:title]).to eq questionnaire.title
      expect(json[:key]).to eq questionnaire.key
      expect(json[:name]).to eq questionnaire.name
      expect(json[:content].as_json).to eq questionnaire.content.as_json
    end
  end
end
