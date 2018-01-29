# frozen_string_literal: true

require 'rails_helper'

describe ResponseContent do
  it 'should have valid default properties' do
    responsecontent = FactoryBot.build(:response_content)
    expect(responsecontent.valid?).to be_truthy
  end

  describe 'content' do
    it 'should accept nil' do
      responsecontent = FactoryBot.build(:response_content, content: nil)
      expect(responsecontent.valid?).to be_truthy
    end
    it 'should accept an empty hash' do
      responsecontent = FactoryBot.build(:response_content, content: {})
      expect(responsecontent.valid?).to be_truthy
    end
    it 'should accept a hash' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      responsecontent = FactoryBot.create(:response_content, content: content_hash)
      expect(responsecontent.content['v4']).to eq 'goed'
      expect(responsecontent.content['v5']).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content['v6']).to eq 36.2
      expect(responsecontent.content).to eq content_hash
      response_id = responsecontent.id
      responsecontent = ResponseContent.find(response_id)
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
