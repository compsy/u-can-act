# frozen_string_literal: true

require 'rails_helper'

describe Questionnaire do
  it 'should have valid default properties' do
    questionnaire = FactoryGirl.build(:questionnaire)
    expect(questionnaire.valid?).to be_truthy
  end

  describe 'name' do
    it 'should not allow two questionnaires with the same name' do
      questionnaireone = FactoryGirl.create(:questionnaire, name: 'myquestionnaire')
      expect(questionnaireone.valid?).to be_truthy
      questionnaireonetwo = FactoryGirl.build(:questionnaire, name: 'myquestionnaire')
      expect(questionnaireonetwo.valid?).to be_falsey
      expect(questionnaireonetwo.errors.messages).to have_key :name
      expect(questionnaireonetwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'should not accept a nil name' do
      questionnaire = FactoryGirl.build(:questionnaire, name: nil)
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank name' do
      questionnaire = FactoryGirl.build(:questionnaire, name: '')
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'content' do
    it 'should not be nil' do
      questionnaire = FactoryGirl.build(:questionnaire, content: nil)
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'should not be blank' do
      questionnaire = FactoryGirl.build(:questionnaire, content: [])
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'should accept a serialized array of hashes' do
      given_content = [
        { id: :v1, type: :range, title: 'Bent u gelukkig?', labels: %w[Nee Ja] }
      ]
      questionnaire = FactoryGirl.build(:questionnaire, content: given_content)
      expect(questionnaire.valid?).to be_truthy
      expect(questionnaire.content[0][:id]).to eq :v1
      expect(questionnaire.content).to eq given_content
    end
  end

  describe 'measurements' do
    it 'should destroy the measurements when destroying the questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocol = FactoryGirl.create(:protocol)
      FactoryGirl.create(:measurement)
      FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      meascountbefore = Measurement.count
      protocolcountbefore = Protocol.count
      questionnairecountbefore = Questionnaire.count
      questionnaire.destroy
      expect(Questionnaire.count).to eq(questionnairecountbefore - 1)
      expect(Measurement.count).to eq(meascountbefore - 1)
      expect(Protocol.count).to eq protocolcountbefore
    end
  end

  describe 'informed_consent_protocols' do
    it 'should be able to create an informed_consent_protocol' do
      questionnaire = FactoryGirl.create(:questionnaire)
      expect(questionnaire.informed_consent_protocols.count).to eq 0
      protocol = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      questionnaire = FactoryGirl.create(:questionnaire)
      expect(questionnaire.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(questionnaire.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
