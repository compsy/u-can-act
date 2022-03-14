# frozen_string_literal: true

require 'rails_helper'

describe Api::QuestionnaireSerializer do
  subject(:json) { described_class.new(questionnaire).as_json.with_indifferent_access }

  let!(:questionnaire) { FactoryBot.create(:questionnaire) }

  describe 'renders the correct json' do
    it 'contains the correct variables' do
      expect(json).not_to be_nil
      expect(json.keys).to eq(%w[title key name content response_count])
      expect(json[:title]).to eq questionnaire.title
      expect(json[:key]).to eq questionnaire.key
      expect(json[:name]).to eq questionnaire.name
      expect(json[:content].as_json).to eq questionnaire.content.as_json
    end

    describe 'response_count' do
      context 'when the questionnaire has no responses' do
        it 'returns 0' do
          expect(json['response_count']).to eq 0
        end
      end

      context 'when the questionnaire has responses' do
        let(:measurement) { FactoryBot.create :measurement, questionnaire: questionnaire }
        let!(:response) { FactoryBot.create_list :response, 2, measurement: measurement }
        it 'returns the correct number of responses' do
          expect(json['response_count']).to eq 2
        end
      end
    end
  end
end
