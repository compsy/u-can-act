# frozen_string_literal: true

require 'rails_helper'

describe ResponseContent do
  it 'has valid default properties' do
    responsecontent = FactoryBot.create(:response_content)
    expect(responsecontent).to be_valid
  end

  describe 'content' do
    it 'accepts nil' do
      responsecontent = FactoryBot.create(:response_content, content: nil)
      expect(responsecontent).to be_valid
    end
    it 'accepts an empty hash' do
      responsecontent = FactoryBot.create(:response_content, content: {})
      expect(responsecontent).to be_valid
    end
    it 'accepts a hash' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      responsecontent = FactoryBot.create(:response_content, content: content_hash)
      expect(responsecontent.content['v4']).to eq 'goed'
      expect(responsecontent.content['v5']).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content['v6']).to eq 36.2
      expect(responsecontent.content).to eq content_hash
      response_id = responsecontent.id
      responsecontent = described_class.find(response_id)
      # Retrieving properties by their symbol names is possible after
      # reading the object from the MongoDB, but not before (when created
      # only as a FactoryBot object).
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
    end
  end

  describe 'create_with_scores!' do
    it 'enriches the content' do
      questionnaire = FactoryBot.create(:questionnaire, content: {
                                          questions: [{ id: :v1, title: 'hoi', type: :number }],
                                          scores: [{ id: :s1, label: 'my-label', ids: %i[v1], operation: :average }]
                                        })
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      response = FactoryBot.create(:response, measurement: measurement)
      content = { 'v1' => '23' }
      expected = { 's1' => '23' }
      rescontent = described_class.create_with_scores!(content: content, response: response)
      expect(rescontent.content).to eq content
      expect(rescontent.scores).to eq expected
    end
  end

  describe 'create_informed_consent_with_scores!' do
    it 'enriches the content' do
      questionnaire = FactoryBot.create(:questionnaire, content: {
                                          questions: [{ id: :v1, title: 'hoi', type: :number }],
                                          scores: [{ id: :s1, label: 'my-label', ids: %i[v1], operation: :average }]
                                        })
      protocol = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire)
      protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
      content = { 'v1' => '23' }
      expected = { 's1' => '23' }
      rescontent = described_class.create_informed_consent_with_scores!(content: content,
                                                                        protocol_subscription: protocol_subscription)
      expect(rescontent.content).to eq content
      expect(rescontent.scores).to eq expected
    end
  end
end
