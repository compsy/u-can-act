# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::QuestionnaireController, type: :controller do
  let(:questionnaire) { FactoryBot.create(:questionnaire) }
  let(:other_response) { FactoryBot.create(:response) }

  describe 'show' do
    let!(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:team) { FactoryBot.create(:team, :with_roles) }
    let!(:the_payload) do
      { ENV['SITE_LOCATION'] => {
        'access_level' => ['user'],
        'team' => team.name,
        'protocol' => protocol.name
      } }
    end

    describe 'general' do
      let!(:questionnaire) { FactoryBot.create(:questionnaire) }
      let!(:the_params) { { key: questionnaire.key } }
      it_behaves_like 'a jwt authenticated route', 'get', :show
    end

    describe 'specific' do
      before do
        the_payload[:sub] = the_auth_user.auth0_id_string
        jwt_auth the_payload
      end

      it 'sets the correct env vars if the questionnaire is available' do
        get :show, params: { key: questionnaire.key }
        expect(response.status).to eq 200
        expect(controller.instance_variable_get(:@questionnaire)).to eq(questionnaire)
      end

      it 'calls the correct serializer' do
        allow(controller).to receive(:render)
          .with(json: questionnaire, serializer: Api::QuestionnaireSerializer)
          .and_call_original
        get :show, params: { key: questionnaire.key }
      end

      it 'renders the correct json' do
        get :show, params: { key: questionnaire.key }
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['title']).to eq questionnaire.title
        expect(json['key']).to eq questionnaire.key
        expect(json['name']).to eq questionnaire.name
        expect(json['content'].as_json).to eq questionnaire.content.as_json
      end

      it 'throws a 404 if the questionnaire does not exist' do
        get :show, params: { key: 192_301 }
        expect(response.status).to eq 404
        expect(response.body).to include 'Vragenlijst met die key niet gevonden'
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end

  describe 'GET #index' do
    let!(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:team) { FactoryBot.create(:team, :with_roles) }
    let(:questionnaires) { FactoryBot.create_list(:questionnaire, 10) }
    let!(:the_payload) do
      { ENV['SITE_LOCATION'] => {
        'access_level' => ['user'],
        'team' => team.name,
        'protocol' => protocol.name
      } }
    end

    before :each do
      the_payload[:sub] = FactoryBot.create(:auth_user, :admin).auth0_id_string
      jwt_auth the_payload
    end

    it 'returns the correct keys' do
      get :index
      expect(response.status).to eq 200
      parsed = JSON.parse(response.body)
      parsed.each do |quest|
        expect(quest.keys).to match_array %w[key title]
      end
    end

    it 'should have the correct list (based on length)' do
      get :index
      expect(response.status).to eq 200
      parsed = JSON.parse(response.body)
      expect(parsed.length).to eq Questionnaire.all.length
    end

    it 'returns the correct keys' do
      get :index
      expect(response.status).to eq 200
      parsed = JSON.parse(response.body)
      Questionnaire.all.each do |expected|
        expect(parsed.any? { |result| result['key'] == expected.key }).to be_truthy
        expect(parsed.any? { |result| result['title'] == expected.title }).to be_truthy
      end
    end
  end

  describe 'create' do
    let!(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:team) { FactoryBot.create(:team, :with_roles) }
    let!(:the_payload) do
      { ENV['SITE_LOCATION'] => {
        'access_level' => ['user'],
        'team' => team.name,
        'protocol' => protocol.name
      } }
    end

    describe 'general' do
      let!(:the_auth_user) { FactoryBot.create(:auth_user, :admin) }
      let!(:questionnaire) { FactoryBot.build(:questionnaire) }
      let!(:the_params) { { questionnaire: questionnaire.attributes } }
      it_behaves_like 'a jwt authenticated route', 'post', :create
    end

    describe 'specific' do
      let!(:questionnaire) { FactoryBot.build(:questionnaire) }
      let!(:the_params) { { questionnaire: questionnaire.attributes } }

      it 'should head 201 if the questionnaire was created' do
        the_payload[:sub] = FactoryBot.create(:auth_user, :admin).auth0_id_string
        jwt_auth the_payload

        post :create, params: the_params
        expect(response.status).to eq 201
      end

      it 'should render a 400 if the provided questionnaire is incorrect' do
        the_payload[:sub] = FactoryBot.create(:auth_user, :admin).auth0_id_string
        jwt_auth the_payload

        post :create, params: { questionnaire: { test: 'nothing' } }
        expect(response.status).to eq 400
        expected = {
          result: {
            name: ['moet opgegeven zijn'],
            content: ['moet opgegeven zijn'],
            key: ['moet opgegeven zijn', 'is ongeldig']
          }
        }.to_json
        expect(response.body).to eq expected
      end

      it 'should throw a 403 if person is not an admin' do
        the_payload[:sub] = the_auth_user.auth0_id_string
        jwt_auth the_payload

        post :create, params: the_params
        expect(response.status).to eq 403
        expected = { result: 'User is not an admin' }.to_json
        expect(response.body).to eq expected
      end
    end
  end
end
