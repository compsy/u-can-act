# frozen_string_literal: true

require 'rails_helper'

describe RecalculateScores do
  describe 'execute' do
    let!(:questionnaire) { FactoryBot.create(:questionnaire) }

    it 'should store the correct results' do
      questionnaire_content = {
        questions: [{ id: :v1, type: :number, title: 'title1' }, { id: :v2, type: :number, title: 'title2' }],
        scores: [{ id: :s1,
                   label: 'average of v1 and v2',
                   ids: %i[v1 v2],
                   operation: :average,
                   require_all: false,
                   round_to_decimals: 1 }]
      }
      questionnaire = FactoryBot.create(:questionnaire, content: questionnaire_content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      old_response_content_content = { 'v1' => '25', 'v2' => '26', 's1' => '27' }
      response_content = FactoryBot.create(:response_content, content: old_response_content_content)
      response_obj = FactoryBot.create(:response, :completed, measurement: measurement)
      response_obj.content = response_content.id
      response_obj.save!
      expect(CalculateDistributionJob).to receive(:perform_later).with(response_obj.id)
      described_class.run!(questionnaire: questionnaire)
      new_response_content_content = { 'v1' => '25', 'v2' => '26', 's1' => '25.5' }
      response_obj.reload
      expect(response_obj.values).to eq(new_response_content_content)
    end
  end
end
