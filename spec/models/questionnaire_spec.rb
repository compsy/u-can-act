# frozen_string_literal: true

require 'rails_helper'

describe Questionnaire do
  describe 'validations' do
    it 'has valid default properties' do
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire).to be_valid
    end

    describe 'all_content_ids_unique' do
      let(:invalid_questionnaire) do
        quest = FactoryBot.create(:questionnaire)
        quest.content[:questions] = [{
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
        FactoryBot.create(:questionnaire, content: { questions: [{
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
                          }], scores: [] })
      end

      it 'is not valid with duplicate keys' do
        expect(invalid_questionnaire).not_to be_valid
        expect(invalid_questionnaire.errors.messages).to have_key :content
        expect(invalid_questionnaire.errors.messages[:content]).to include('can only have a series of unique ids: v1')
      end

      it 'is valid without duplicate keys' do
        expect(valid_questionnaire).to be_valid
        expect(valid_questionnaire.errors.messages).not_to have_key :content
      end

      it 'is not valid with duplicate score keys' do
        valid_questionnaire.content[:scores] = [{ id: :v1, label: 'something', ids: [:v2], operation: :average }]
        expect(valid_questionnaire).not_to be_valid
        expect(valid_questionnaire.errors.messages).to have_key :content
        expect(valid_questionnaire.errors.messages[:content]).to include('can only have a series of unique ids: v1')
      end
    end

    describe 'all_questions_have_types' do
      it 'is not valid with an empty question' do
        content = { questions: [{}], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :type attribute: [nil]\n")
        )
      end

      it 'is not valid with a question without type' do
        content = { questions: [{ id: :v1, title: 'hoi' }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :type attribute: [:v1]\n")
        )
      end

      it 'is valid with a question with a type' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'all_questions_have_titles' do
      it 'is not valid with an empty question' do
        content = { questions: [{}], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :title attribute: [nil]\n")
        )
      end

      it 'is not valid with a question without title' do
        content = { questions: [{ id: :v1, type: :number }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :title attribute: [:v1]\n")
        )
      end

      it 'is valid with a question with a title' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end

      it 'is valid without a title if it is a raw' do
        content = { questions: [{ type: :raw }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end

      it 'is valid without a title if it is an unsubcribe' do
        content = { questions: [{ type: :unsubscribe }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'all_questions_have_ids' do
      it 'is not valid with an empty question' do
        content = { questions: [{}], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :id attribute: [nil]\n")
        )
      end

      it 'is not valid with a question without id' do
        content = { questions: [{ title: 'hoi', type: :number }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include("the following questions are missing the required :id attribute: [\"hoi\"]\n")
        )
      end

      it 'is valid with a question with an id' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end

      it 'is valid without an id if it is a raw' do
        content = { questions: [{ type: :raw }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end

      it 'is valid without an id if it is an unsubscribe' do
        content = { questions: [{ type: :unsubscribe }], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'questionnaire_structure' do
      it 'does not accept an array' do
        content = []
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('needs to be a Hash with :questions and :scores components')
        )
      end
      it 'does not accept an empty hash' do
        content = {}
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('needs to be a Hash with :questions and :scores components')
        )
      end
      it 'does accept a hash with score and questions components' do
        content = { questions: [], scores: [] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'all_scores_have_required_atributes' do
      it 'does not accept scores without an id' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ label: 'my-label', ids: %i[v1], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores are missing one or more required attributes: my-label')
        )
      end

      it 'does not accept scores without a label' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, ids: %i[v1], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores are missing one or more required attributes: :s1')
        )
      end

      it 'does not accept scores without ids' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores are missing one or more required attributes: my-label')
        )
      end

      it 'does not accept scores with empty ids' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: [], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores have an empty ids attribute: my-label')
        )
      end

      it 'does not accept scores without an operation' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[v1] }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores are missing one or more required attributes: my-label')
        )
      end

      it 'does accept scores with all required attributes' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[v1], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'all_scores_use_existing_ids' do
      it 'does not allow for ids that don\'t exist' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[v2], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores use ids that do not exist in their context: my-label')
        )
      end
      it 'does not allow for ids of future scores' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[s2], operation: :average },
                             { id: :s2, label: 'my-label2', ids: %i[v1], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores use ids that do not exist in their context: my-label')
        )
      end
      it 'does allow for ids of previous scores' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[v2], operation: :average },
                             { id: :s2, label: 'my-label2', ids: %i[s1], operation: :average }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).to be_valid
      end
    end

    describe 'all_scores_have_known_operations' do
      it 'does not allow for operations that do not exist' do
        content = { questions: [{ id: :v1, title: 'hoi', type: :number }],
                    scores: [{ id: :s1, label: 'my-label', ids: %i[v2], operation: :diffusion }] }
        questionnaire = FactoryBot.build(:questionnaire, content: content)
        expect(questionnaire).not_to be_valid
        expect(questionnaire.errors.messages).to have_key :content
        expect(questionnaire.errors.messages[:content]).to(
          include('the following scores have an unknown operation: my-label')
        )
      end
    end
  end

  describe 'responses' do
    it 'counts all the responses that it is used for' do
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
    it 'does not allow two questionnaires with the same name' do
      questionnaireone = FactoryBot.create(:questionnaire, name: 'myquestionnaire')
      expect(questionnaireone).to be_valid
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.name = 'myquestionnaire'
      expect(questionnaireonetwo).not_to be_valid
      expect(questionnaireonetwo.errors.messages).to have_key :name
      expect(questionnaireonetwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'does not accept a nil name' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.name = nil
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'does not accept a blank name' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.name = ''
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :name
      expect(questionnaire.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'key' do
    it 'does not allow two questionnaires with the same key' do
      questionnaireone = FactoryBot.create(:questionnaire, key: 'myquestionnaire')
      expect(questionnaireone).to be_valid
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.key = 'myquestionnaire'
      expect(questionnaireonetwo).not_to be_valid
      expect(questionnaireonetwo.errors.messages).to have_key :key
      expect(questionnaireonetwo.errors.messages[:key]).to include('is al in gebruik')
    end
    it 'does not allow two questionnaires with the same key in the database' do
      FactoryBot.create(:questionnaire, key: 'myquestionnaire')
      questionnaireonetwo = FactoryBot.create(:questionnaire)
      questionnaireonetwo.key = 'myquestionnaire'
      expect { questionnaireonetwo.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'does not accept a nil key' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = nil
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('moet opgegeven zijn')
    end
    it 'does not accept a blank key' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = ''
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('moet opgegeven zijn')
    end
    it 'does not allow a key with spaces' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = 'niet goed'
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'does not allow a key that starts with a number' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = '0nietgoed'
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'does not allow a key that starts with a _' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = '_nietgoed'
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :key
      expect(questionnaire.errors.messages[:key]).to include('is ongeldig')
    end
    it 'allows a key that starts with a char and contains _ and number' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.key = 'goede_key_hier0123'
      expect(questionnaire).to be_valid
    end
  end

  describe 'title' do
    it 'allows two questionnaires with the same title' do
      questionnaireone = FactoryBot.create(:questionnaire, title: 'myquestionnaire')
      expect(questionnaireone).to be_valid
      questionnaireonetwo = FactoryBot.create(:questionnaire, title: 'myquestionnaire')
      expect(questionnaireonetwo).to be_valid
    end
    it 'accepts a nil title' do
      questionnaire = FactoryBot.create(:questionnaire, title: nil)
      expect(questionnaire).to be_valid
      questionnaire.save!
      questionnaire = described_class.find_by(id: questionnaire.id)
      expect(questionnaire.title).to be_nil
    end
    it 'accepts a blank title' do
      questionnaire = FactoryBot.create(:questionnaire, title: '')
      expect(questionnaire).to be_valid
      questionnaire.save!
      questionnaire = described_class.find_by(id: questionnaire.id)
      expect(questionnaire.title).to eq ''
    end
    it 'is able to retrieve a normal title' do
      questionnaire = FactoryBot.create(:questionnaire, title: 'my own title')
      expect(questionnaire).to be_valid
      questionnaire.save!
      questionnaire = described_class.find_by(id: questionnaire.id)
      expect(questionnaire.title).to eq 'my own title'
    end
  end

  describe 'content' do
    it 'is not nil' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.content = nil
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'is not blank' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire.content = []
      expect(questionnaire).not_to be_valid
      expect(questionnaire.errors.messages).to have_key :content
      expect(questionnaire.errors.messages[:content]).to include('moet opgegeven zijn')
    end
    it 'accepts a serialized array of hashes' do
      given_content = { questions: [
        { id: :v1, type: :range, title: 'Bent u gelukkig?', labels: %w[Nee Ja] }
      ], scores: [] }
      questionnaire = FactoryBot.create(:questionnaire, content: given_content)
      expect(questionnaire).to be_valid
      expect(questionnaire.content[0][:id]).to eq :v1
      expect(questionnaire.content).to eq given_content
    end
  end

  describe 'measurements' do
    it 'destroys the measurements when destroying the questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire)
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement)
      FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      meascountbefore = Measurement.count
      protocolcountbefore = Protocol.count
      questionnairecountbefore = described_class.count
      questionnaire.destroy
      expect(described_class.count).to eq(questionnairecountbefore - 1)
      expect(Measurement.count).to eq(meascountbefore - 1)
      expect(Protocol.count).to eq protocolcountbefore
    end
  end

  describe 'informed_consent_protocols' do
    it 'is able to create an informed_consent_protocol' do
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire.informed_consent_protocols.count).to eq 0
      protocol = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      questionnaire = FactoryBot.create(:questionnaire)
      expect(questionnaire.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(questionnaire.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
