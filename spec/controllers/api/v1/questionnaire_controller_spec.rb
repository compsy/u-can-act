# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::QuestionnaireController, type: :controller do
  render_views
  let(:questionnaire) { FactoryBot.create(:questionnaire) }
  let(:other_response) { FactoryBot.create(:response) }

  describe 'create' do
    context 'correct request' do
      let(:content) do
        [{
          type: :raw,
          content: 'content here!'
        }].to_json
      end

      it 'should head 200' do
        post :create, params: { content: questionnaire }
        expect(response.status).to eq 200
      end

      it 'should return a HTML version of the passed-in json' do
        expected = '<div class="row section"><div class="col s12">content here!</div></div>'
        post :create, params: { content: questionnaire }
        expect(response.body).to include expected
      end
    end

    context 'wront request' do
      let(:content) { 'notjson' }
      it 'should head 400' do
        post :create, params: { content: content }
        expect(response.status).to eq 400
      end

      it 'should return some error message' do
        post :create, params: { content: content }
        expect(response.body).to eq({ error: "765: unexpected token at 'notjson'" }.to_json)
      end
    end
  end

  describe 'show' do
    it 'should set the correct env vars if the questionnaire is available' do
      get :show, params: { key: questionnaire.key }
      expect(response.status).to eq 200
      expect(controller.instance_variable_get(:@questionnaire)).to eq(questionnaire)
    end

    it 'should call the correct serializer' do
      allow(controller).to receive(:render)
        .with(json: questionnaire, serializer: Api::QuestionnaireSerializer)
        .and_call_original
      get :show, params: { key: questionnaire.key }
    end

    it 'should render the correct json' do
      get :show, params: { key: questionnaire.key }
      expect(response.status).to eq 200
      expect(response.header['Content-Type']).to include 'application/json'
      json = JSON.parse(response.body)
      expect(json).to_not be_nil
      expect(json['title']).to eq questionnaire.title
      expect(json['key']).to eq questionnaire.key
      expect(json['name']).to eq questionnaire.name
      expect(json['content'].as_json).to eq questionnaire.content.as_json
    end

    it 'should throw a 404 if the questionnaire does not exist' do
      get :show, params: { key: 192_301 }
      expect(response.status).to eq 404
      expect(response.body).to include 'Vragenlijst met die key niet gevonden'
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
