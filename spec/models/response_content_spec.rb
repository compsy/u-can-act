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
end
