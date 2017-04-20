# frozen_string_literal: true

require 'rails_helper'

describe Response do
  it 'should have valid default properties' do
    response = FactoryGirl.build(:response)
    expect(response.valid?).to be_truthy
  end

  it 'should have valid default completed properties' do
    response = FactoryGirl.build(:response, :completed)
    expect(response.valid?).to be_truthy
  end

  describe 'protocol_subscription_id' do
    it 'should have one' do
      response = FactoryGirl.build(:response, protocol_subscription_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :protocol_subscription_id
      expect(response.errors.messages[:protocol_subscription_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a ProtocolSubscription' do
      response = FactoryGirl.create(:response)
      expect(response.protocol_subscription).to be_a(ProtocolSubscription)
    end
  end

  describe 'measurement_id' do
    it 'should have one' do
      response = FactoryGirl.build(:response, measurement_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :measurement_id
      expect(response.errors.messages[:measurement_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Measurement' do
      response = FactoryGirl.create(:response)
      expect(response.measurement).to be_a(Measurement)
    end
  end

  describe 'content' do
    it 'should accept nil' do
      response = FactoryGirl.build(:response, content: nil)
      expect(response.valid?).to be_truthy
    end
    it 'should accept an empty hash' do
      response = FactoryGirl.build(:response, content: {})
      expect(response.valid?).to be_truthy
    end
    it 'should accept a serialized array of hashes' do
      given_content = { v4: 'goed', v5: ['brood', 'kaas en ham'], v6: 36.2 }
      response = FactoryGirl.create(:response, content: given_content)
      expect(response.content[:v4]).to eq 'goed'
      expect(response.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(response.content[:v6]).to eq 36.2
      expect(response.content).to eq given_content
      response_id = response.id
      response = Response.find(response_id)
      expect(response.content[:v4]).to eq 'goed'
      expect(response.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(response.content[:v6]).to eq 36.2
      expect(response.content).to eq given_content
    end
  end

  describe 'open_from' do
    it 'should not be nil' do
      response = FactoryGirl.build(:response, open_from: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :open_from
      expect(response.errors.messages[:open_from]).to include('moet opgegeven zijn')
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      response = FactoryGirl.build(:response)
      response.invited_state = Response::NOT_SENT_STATE
      expect(response.valid?).to be_truthy
      response = FactoryGirl.build(:response)
      response.invited_state = Response::SENDING_STATE
      expect(response.valid?).to be_truthy
      response = FactoryGirl.build(:response)
      response.invited_state = Response::SENT_STATE
      expect(response.valid?).to be_truthy
    end
    it 'should not be nil' do
      response = FactoryGirl.build(:response, invited_state: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      response = FactoryGirl.build(:response, invited_state: '')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      response = FactoryGirl.build(:response, invited_state: 'somestring')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      response = FactoryGirl.create(:response)
      expect(response.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(response.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
