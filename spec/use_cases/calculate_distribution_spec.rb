# frozen_string_literal: true

require 'rails_helper'

describe CalculateDistribution do
  describe 'execute' do
    let!(:questionnaire) { FactoryBot.create(:questionnaire) }

    it 'should store the correct results' do
      reponse_content = FactoryBot.create(:response_content, content: { 'v3' => '68' })
      response = FactoryBot.create(:response, :completed)
      response.content = reponse_content.id
      response.save!
      expected = { 'total' => 1, 'v3' => {} }
      (0..100).each do |val|
        expected['v3'][val.to_s] = 0
      end
      expected['v3']['68'] = 1
      expect(RedisService).to receive(:set).with("distribution_#{response.measurement.questionnaire.key}",
                                                 expected.to_json)
      expect(described_class.run!(questionnaire: response.measurement.questionnaire))
    end
  end
end
