# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ResponseController, type: :controller do
  let!(:person) { FactoryBot.create(:person) }
  let!(:response1) { FactoryBot.create(:response, :not_expired) }
  let!(:response2) { FactoryBot.create(:response, :not_expired) }
  let!(:response3) { FactoryBot.create(:response, :future) }
  let!(:response4) { FactoryBot.create(:response, :completed) }

  before :each do
    response1.protocol_subscription.update_attributes!(
      person: person,
      filling_out_for: person,
      responses: [
        response1,
        response2,
        response3,
        response4
      ]
    )
  end

  describe 'requires basic authentication' do
    it 'should require basic auth for show' do
      get :show, params: { uuid: response1.uuid }
      expect(response.status).to eq 401
    end

    it 'should require basic auth for index' do
      get :index
      expect(response.status).to eq 401
    end

    it 'should require basic auth for create' do
      post :create
      expect(response.status).to eq 401
    end
  end

  describe 'authenticated' do
    before :each do
      basic_api_auth name: ENV['API_KEY'], password: ENV['API_SECRET']
    end

    describe 'show' do
      it 'should head a 200' do
        get :show, params: { uuid: response1.uuid }
        expect(response.status).to eq 200
      end

      it 'should render the response json belonging to the uuid' do
        get :show, params: { uuid: response1.uuid }
        expect(response.header['Content-Type']).to include 'application/json'

        expect(response.body).to_not be_nil
        json = JSON.parse(response.body)
        expect(json).to_not be_nil
        expect(json['uuid']).to eq response1.uuid
        expect(json['questionnaire_title']).to eq response1.measurement.questionnaire.name
        expect(json['questionnaire_content']).to_not be_nil
        expect(json['questionnaire_content'].as_json)
          .to eq(response1.measurement.questionnaire.content.as_json)
      end

      it 'should use the PersonalizedQuestionnaireSerializer for rendering' do
        allow(controller).to receive(:render)
          .with(json: response1, serializer: Api::PersonalizedQuestionnaireSerializer)
          .and_call_original
        get :show, params: { uuid: response1.uuid }
      end

      it 'should render a 404 if the requested uuid is not found' do
        get :show, params: { uuid: 'non-exis-tent' }
        expect(response.status).to eq 404
        expect(response.body).to_not be_nil
        expect(response.body).to eq 'Response met die key niet gevonden'
      end

      it 'should set the correct instance variables' do
        get :show, params: { uuid: response1.uuid }
        expect(controller.instance_variable_get(:@response)).to_not be_nil
        expect(controller.instance_variable_get(:@response)).to eq response1
      end
    end

    describe 'index' do
      it 'should head a 200' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(response.status).to eq 200
      end

      it 'should list all open questionnairs that belong to the current user' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(response.header['Content-Type']).to include 'application/json'

        expect(response.body).to_not be_nil
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        [response1, response2].each_with_index do |resp, index|
          expect(json[index]['uuid']).to eq(resp.uuid)
          expect(json[index]['questionnaire']['key']).to eq(resp.measurement.questionnaire.key)
          expect(json[index]['questionnaire']['name']).to eq(resp.measurement.questionnaire.name)
          expect(json[index]['questionnaire']['title']).to eq(resp.measurement.questionnaire.title)
        end
      end

      it 'should use the ResponseSerializer for rendering' do
        allow(controller).to receive(:render)
          .with(json: [response1, response2], each_serializer: Api::ResponseSerializer)
          .and_call_original
        get :index, params: { external_identifier: person.external_identifier }
      end

      it 'should render a 404 if the requested person is not found' do
        get :index, params: { external_identifier: 'wrong' }
        expect(response.status).to eq 404
        expect(response.body).to_not be_nil
        expect(response.body).to eq 'Persoon met die external_identifier niet gevonden'
      end

      it 'should set the correct instance variables' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(controller.instance_variable_get(:@responses)).to_not be_nil
        expect(controller.instance_variable_get(:@responses)).to eq [response1, response2]
      end
    end

    describe 'create' do
    end
  end
end
