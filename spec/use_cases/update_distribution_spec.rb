# frozen_string_literal: true

require 'rails_helper'

describe UpdateDistribution do
  describe 'execute' do
    let!(:questionnaire) { FactoryBot.create(:questionnaire) }

    it 'should store the correct results' do
      reponse_content = FactoryBot.create(:response_content, content: { 'v3' => '68' })
      responseobj = FactoryBot.create(:response)
      responseobj.content = reponse_content.id
      responseobj.save!
      expected = { 'total' => 1, 'v3' => {} }
      (0..100).each do |val|
        expected['v3'][val.to_s] = 0
      end
      initial_distribution = expected.deep_dup
      expected['v3']['68'] = 1
      expected['total'] = 2
      expect(initial_distribution['v3']['68']).to eq(0)
      expect(RedisService).to(receive(:get).with(
        "distribution_#{responseobj.measurement.questionnaire.key}"
      ).and_return(initial_distribution.to_json))
      expect(RedisService).to receive(:set).with("distribution_#{responseobj.measurement.questionnaire.key}",
                                                 expected.to_json)
      expect(described_class.run!(questionnaire: responseobj.measurement.questionnaire, response: responseobj))
    end
  end
end
