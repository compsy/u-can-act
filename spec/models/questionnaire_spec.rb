# frozen_string_literal: true

require 'rails_helper'

describe Questionnaire do
  describe 'validations' do
    it 'should have valid default properties' do
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire.valid?).to be_truthy
    end

    describe 'all_content_ids_unique' do
      let(:invalid_questionnaire) do
        quest = FactoryBot.create(:questionnaire)
        quest.content = [{
          section_start: 'Algemeen',
          id: :v1,
          type: :radio,
          title: 'Hoe voelt u zich vandaag?',
          options: %w[slecht goed],
          otherwise_label: 'Anders nog wat:'
        }, {
          section_start: 'Algemeen',
          id: :v2,
          type: :radio,
          title: 'Hoe voelt u zich vandaag?',
          options: %w[slecht goed],
          otherwise_label: 'Anders nog wat:'
        }, {
          id: :v1,
          type: :checkbox,
          title: 'Wat heeft u vandaag gegeten?',
          options: ['brood', 'kaas en ham', 'pizza'],
          otherwise_label: 'Hier ook iets:'
        }]
        quest
      end
      let(:valid_questionnaire) do
        FactoryBot.create(:questionnaire, content: [{
                            section_start: 'Algemeen',
                            id: :v1,
                            type: :radio,
                            title: 'Hoe voelt u zich vandaag?',
                            options: %w[slecht goed],
                            otherwise_label: 'Anders nog wat:'
                          }, {
                            id: :v2,
                            type: :checkbox,
                            title: 'Wat heeft u vandaag gegeten?',
                            options: ['brood', 'kaas en ham', 'pizza'],
                            otherwise_label: 'Hier ook iets:'
                          }])
      end

      it 'should not be valid with duplicate keys' do
        expect(invalid_questionnaire).to_not be_valid
        expect(invalid_questionnaire.errors.messages).to have_key :content
        expect(invalid_questionnaire.errors.messages[:content]).to include('can only have a series of unique ids')
      end

      it 'should be valid without duplicate keys' do
        expect(valid_questionnaire).to be_valid
        expect(valid_questionnaire.errors.messages).to_not have_key :content
      end
    end
  end

  describe 'responses' do
    it 'should count all the responses that it is used for' do
      questionnaire = FactoryBot.create(:questionnaire)
      measurement1 = FactoryBot.create(:measurement, questionnaire: questionnaire)
      measurement2 = FactoryBot.create(:measurement, questionnaire: questionnaire)
      measurement3 = FactoryBot.create(:measurement)
      FactoryBot.create_list(:response, 5, measurement: measurement1)
      FactoryBot.create_list(:response, 7, :completed, measurement: measurement2)
      FactoryBot.create_list(:response, 27, measurement: measurement3)
      expect(questionnaire.responses.count).to eq 12
      expect(questionnaire.responses.completed.count).to eq 7
    end
  end

  describe 'name' do
    it 'should not allow two questionnaires with the same name' do
      questionnaireone = FactoryBot.create(:questionnaire, name: 'myquestionnaire')
      expect(questionnaireone.valid?).to be_truthy
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.name = 'myquestionnaire'
      expect(questionnaireonetwo.valid?).to be_falsey
      expect(questionnaireonetwo.errors.messages).to have_key :name
      expect(questionnaireonetwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'should not accept a nil name' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.name = nil
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank name' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.name = ''
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'key' do
    it 'should not allow two questionnaires with the same key' do
      questionnaireone = FactoryBot.create(:questionnaire, key: 'myquestionnaire')
      expect(questionnaireone.valid?).to be_truthy
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.key = 'myquestionnaire'
      expect(questionnaireonetwo.valid?).to be_falsey
      expect(questionnaireonetwo.errors.messages).to have_key :key
      expect(questionnaireonetwo.errors.messages[:key]).to include('is al in gebruik')
    end
    it 'should not allow two questionnaires with the same key in the database' do
      FactoryBot.create(:questionnaire, key: 'myquestionnaire')
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.key = 'myquestionnaire'
      expect { questionnaireonetwo.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'should not accept a nil key' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = nil
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank key' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = ''
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('moet opgegeven zijn')
    end
    it 'should not allow a key with spaces' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = 'niet goed'
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'should not allow a key that starts with a number' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = '0nietgoed'
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'should not allow a key that starts with a _' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = '_nietgoed'
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'should allow a key that starts with a char and contains _ and number' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = 'goede_key_hier0123'
      expect(questionnaire.valid?).to be_truthy
    end
  end

  describe 'title' do
    it 'should allow two questionnaires with the same title' do
      questionnaireone = FactoryBot.create(:questionnaire, title: 'myquestionnaire')
      expect(questionnaireone.valid?).to be_truthy
      questionnaireonetwo = FactoryBot.create(:questionnaire, title: 'myquestionnaire')
      expect(questionnaireonetwo.valid?).to be_truthy
    end
    it 'should accept a nil title' do
      questionnaire = FactoryBot.create(:questionnaire, title: nil)
      expect(questionnaire.valid?).to be_truthy
      questionnaire.save!
      questionnaire = Questionnaire.find_by_id(questionnaire.id)
      expect(questionnaire.title).to be_nil
    end
    it 'should accept a blank title' do
      questionnaire = FactoryBot.create(:questionnaire, title: '')
      expect(questionnaire.valid?).to be_truthy
      questionnaire.save!
      questionnaire = Questionnaire.find_by_id(questionnaire.id)
      expect(questionnaire.title).to eq ''
    end
    it 'should be able to retrieve a normal title' do
      questionnaire = FactoryBot.create(:questionnaire, title: 'my own title')
      expect(questionnaire.valid?).to be_truthy
      questionnaire.save!
      questionnaire = Questionnaire.find_by_id(questionnaire.id)
      expect(questionnaire.title).to eq 'my own title'
    end
  end

  describe 'content' do
    it 'should not be nil' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.content = nil
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'should not be blank' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.content = []
      expect(questionnaire.valid?).to be_falsey
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'should accept a serialized array of hashes' do
      given_content = [
        { id: :v1, type: :range, title: 'Bent u gelukkig?', labels: %w[Nee Ja] }
      ]
      questionnaire = FactoryBot.create(:questionnaire, content: given_content)
      expect(questionnaire.valid?).to be_truthy
      expect(questionnaire.content[0][:id]).to eq :v1
      expect(questionnaire.content).to eq given_content
    end
  end

  describe 'measurements' do
    it 'should destroy the measurements when destroying the questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire)
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement)
      FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
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
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire.informed_consent_protocols.count).to eq 0
      protocol = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(questionnaire.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
