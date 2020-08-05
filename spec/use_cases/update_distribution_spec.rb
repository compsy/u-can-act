# frozen_string_literal: true

require 'rails_helper'

describe UpdateDistribution do
  describe 'execute' do
    it 'should store the correct results' do
      response_content = FactoryBot.create(:response_content, content: { 'v3' => '68' })
      responseobj = FactoryBot.create(:response)
      responseobj.content = response_content.id
      responseobj.save!
      initial_distribution = { 'total' => 1 }
      expected = initial_distribution.deep_dup
      expected['v3'] = { '_min' => 0, '_max' => 100, '_step' => 1, '68' => { '_' => 1 } }
      expected['total'] = 2
      expect(RedisService).to(receive(:get).with(
        "distribution_#{responseobj.measurement.questionnaire.key}"
      ).and_return(initial_distribution.to_json))
      expect(RedisService).to receive(:set).with("distribution_#{responseobj.measurement.questionnaire.key}",
                                                 expected.to_json)
      described_class.run!(questionnaire: responseobj.measurement.questionnaire, response: responseobj)
    end

    it 'should ignore responses with csrf_failed' do
      response_content = FactoryBot.create(:response_content,
                                           content: { 'v3' => '68', Response::CSRF_FAILED => 'true' })
      responseobj = FactoryBot.create(:response)
      responseobj.content = response_content.id
      responseobj.save!
      initial_distribution = { 'total' => 1 }
      expect(RedisService).to(receive(:get).with(
        "distribution_#{responseobj.measurement.questionnaire.key}"
      ).and_return(initial_distribution.to_json))
      expect(RedisService).to receive(:set).with("distribution_#{responseobj.measurement.questionnaire.key}",
                                                 initial_distribution.to_json)
      described_class.run!(questionnaire: responseobj.measurement.questionnaire, response: responseobj)
    end
  end
end
