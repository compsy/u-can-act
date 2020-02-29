# frozen_string_literal: true

require 'rails_helper'

describe CalculateDistribution do
  describe 'execute' do
    let!(:questionnaire) { FactoryBot.create(:questionnaire) }

    it 'should store the correct results' do
      reponse_content = FactoryBot.create(:response_content, content: { 'v3' => '68' })
      response_obj = FactoryBot.create(:response, :completed)
      response_obj.content = reponse_content.id
      response_obj.save!
      expected = {
        'total' => 1,
        'v3' => {
          '_min' => 0,
          '_max' => 100,
          '_step' => 1,
          '68' => { '_' => 1 }
        }
      }
      expect(RedisService).to receive(:set).with("distribution_#{response_obj.measurement.questionnaire.key}",
                                                 expected.to_json)
      expect(described_class.run!(questionnaire: response_obj.measurement.questionnaire))
    end
  end
end
