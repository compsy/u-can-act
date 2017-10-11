# frozen_string_literal: true

require 'rails_helper'

describe Protocol do
  it 'should have valid default properties' do
    protocol = FactoryGirl.build(:protocol)
    expect(protocol.valid?).to be_truthy
  end

  describe 'name' do
    it 'should not allow two protocols with the same name' do
      protocolone = FactoryGirl.create(:protocol, name: 'myprotocol')
      expect(protocolone.valid?).to be_truthy
      protocoltwo = FactoryGirl.build(:protocol, name: 'myprotocol')
      expect(protocoltwo.valid?).to be_falsey
      expect(protocoltwo.errors.messages).to have_key :name
      expect(protocoltwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'should not accept a nil name' do
      protocol = FactoryGirl.build(:protocol, name: nil)
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank name' do
      protocol = FactoryGirl.build(:protocol, name: '')
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'duration' do
    it 'should be a zero or positive integer' do
      protocol = FactoryGirl.build(:protocol)
      protocol.duration = 0
      expect(protocol.valid?).to be_truthy
      protocol.duration = 1.5
      expect(protocol.valid?).to be_falsey
      protocol.duration = -1
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should not be nil' do
      protocol = FactoryGirl.build(:protocol, duration: nil)
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('is geen getal')
    end
  end

  describe 'measurements' do
    it 'should destroy the measurements when destroying the protocol' do
      protocol = FactoryGirl.create(:protocol, :with_measurements)
      expect(protocol.measurements.first).to be_a(Measurement)
      meascountbefore = Measurement.count
      protocol.destroy
      expect(Measurement.count).to eq(meascountbefore - 1)
    end
  end

  describe 'protocol_subscriptions' do
    it 'should destroy the protocol_subscriptions when destroying the protocol' do
      protocol = FactoryGirl.create(:protocol, :with_protocol_subscriptions)
      expect(protocol.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      protocol.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'informed_consent_questionnaire' do
    it 'should be able to set an informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocol = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.valid?).to be_truthy
      expect(protocol.valid?).to be_truthy
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocol.id
    end
    it 'should be able to have multiple protocols with the same informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocols = FactoryGirl.create_list(:protocol, 3, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.valid?).to be_truthy
      protocols.each do |protocol|
        expect(protocol.valid?).to be_truthy
        expect(protocol.informed_consent_questionnaire).to eq questionnaire
        expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      end
      expect(questionnaire.informed_consent_protocols.count).to eq 3
      expect(questionnaire.informed_consent_protocols.first).to eq protocols.first
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocols.first.id
    end
    it 'should not have an informed consent questionnaire by default and still be valid' do
      protocol = FactoryGirl.create(:protocol)
      expect(protocol.valid?).to be_truthy
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'should nullify the attribute when deleting the informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocol_id = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire).id
      protocol = Protocol.find_by_id(protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      questionnairecountbef = Questionnaire.count
      protocolcountbef = Protocol.count
      questionnaire.destroy!
      expect(Questionnaire.count).to eq(questionnairecountbef - 1)
      expect(Protocol.count).to eq protocolcountbef
      protocol = Protocol.find_by_id(protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'should no longer return the protocol once it has been destroyed' do
      questionnaire = FactoryGirl.create(:questionnaire)
      questionnaire_id = questionnaire.id
      protocol = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire = Questionnaire.find_by_id(questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      questionnairecountbef = Questionnaire.count
      protocolcountbef = Protocol.count
      protocol.destroy!
      expect(Questionnaire.count).to eq questionnairecountbef
      expect(Protocol.count).to eq(protocolcountbef - 1)
      questionnaire = Questionnaire.find_by_id(questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 0
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      protocol = FactoryGirl.create(:protocol)
      expect(protocol.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
