# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireGenerator do
  let(:responseobj) { FactoryBot.create(:response) }

  describe 'generate_questionnaire' do # This is the only public method
    it 'generates a questionnaire' do
      result = subject
               .generate_questionnaire(
                 response_id: responseobj.id,
                 content: responseobj.measurement.questionnaire.content,
                 title: 'Dit is een titel {{deze_student}}',
                 submit_text: 'Opslaan',
                 action: '/',
                 unsubscribe_url: Rails.application.routes.url_helpers.questionnaire_path(uuid: responseobj.uuid),
                 locale: Rails.application.config.i18n.default_locale.to_s,
                 params: {
                   authenticity_token: 'authenticity-token'
                 }
               )
      # We already check the semantics of the questionnaire in the feature test, so just
      # check for the hidden fields here and make sure that we get a form.
      expect(result).to include('authenticity-token')
      expect(result).to include(responseobj.id.to_s)
      expect(result).to include('response_id')
      expect(result).to include('utf8')
      expect(result).to include('authenticity_token')
      expect(result).to include('<form')
      expect(result).to include('Jane')
    end
    it 'raises an error when given a question of unknown type' do
      questionnaire_content = [{
        section_start: 'Algemeen',
        id: :v1,
        type: :asdf,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }]
      expect do
        subject.send(:questionnaire_questions_html,
                     questionnaire_content, nil, questionnaire_content, nil)
      end.to raise_error(RuntimeError, 'Unknown question type asdf')
    end
    it 'raises an error when given an unknown show_after type' do
      questionnaire_content = [{
        id: :v1,
        type: :raw,
        content: 'Hoe voelt u zich vandaag?',
        show_after: 'hoi en doei'
      }]
      expect do
        subject.send(:questionnaire_questions_html,
                     questionnaire_content, nil, questionnaire_content, nil)
      end.to raise_error(RuntimeError, 'Unknown show_after type: hoi en doei')
    end
  end

  describe 'generate_json_questionnaire' do
    before do
      questionnaire_content = { questions: [{
        section_start: 'Algemeen',
        id: :v1,
        type: :range,
        title: 'Hoe voelt {{deze_student}} zich vandaag?',
        options: %w[slecht goed]
      }], scores: [] }
      @result = subject.generate_hash_questionnaire(responseobj.id,
                                                    questionnaire_content,
                                                    'Dit is een titel {{deze_student}}')
    end

    it 'returns a hash with the title and content' do
      expect(@result).to be_a Hash
      expect(@result.keys).to match_array %i[title content]
    end

    it 'provides the content of the questionnaire as a hash' do
      expect(@result[:content]).to be_a Array
      expect(@result[:content]).to(be_all { |quest| quest.is_a? Hash })
    end

    it 'replaces names in the json' do
      expect(@result[:content].first[:title]).to include('Jane')
      expect(@result[:content].first[:title]).not_to include('deze_student')
    end

    it 'replaces names in the title' do
      expect(@result[:title]).to include('Jane')
      expect(@result[:title]).not_to include('deze_student')
    end
  end
end
