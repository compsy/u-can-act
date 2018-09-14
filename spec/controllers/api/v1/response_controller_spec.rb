# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ResponseController, type: :controller do
  let!(:person) { FactoryBot.create(:person, :with_auth_user) }
  # Create a the_auth_user here, so the spec won't create it for us
  let!(:the_auth_user) { person.auth_user }

  # the_payload automatically gets used by the shared example
  let!(:the_payload) do
    { ENV['SITE_LOCATION'] => {
      'roles' => ['user'],
      'team' => person.role.team.name,
      'protocol' => response1.protocol_subscription.protocol.name
    } }
  end
  let!(:response1) { FactoryBot.create(:response, :not_expired, open_from: 10.minutes.ago) }
  let!(:response2) { FactoryBot.create(:response, :not_expired, open_from: 8.minutes.ago) }
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

  let!(:team) { FactoryBot.create(:team) }
  let!(:protocol) { FactoryBot.create(:protocol) }

  describe 'show should be authenticated' do
    let!(:the_params) { { uuid: response1.uuid } }
    it_should_behave_like 'a jwt authenticated route', 'get', :show
  end

  describe 'index should be authenticated' do
    it_should_behave_like 'a jwt authenticated route', 'get', :index
  end

  describe 'create should be authenticated' do
    let(:the_params) { { uuid: response2.uuid } }
    it_should_behave_like 'a jwt authenticated route', 'post', :create
  end

  describe 'authenticated' do
    before :each do
      the_payload[:sub] = the_auth_user.auth0_id_string
      jwt_auth the_payload
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
        expect(json['questionnaire_title']).to eq response1.measurement.questionnaire.title
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
        expect(response.body).to eq({ result: 'Response met dat uuid niet gevonden' }.to_json)
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
        jwt_auth(sub: FactoryBot.create(:auth_user).auth0_id_string)
        get :index
        expect(response.status).to eq 404
        expect(response.body).to_not be_nil
        expected = { result: 'Deelnemer niet gevonden' }.to_json
        expect(response.body).to eq expected
      end

      it 'should set the correct instance variables' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(controller.instance_variable_get(:@responses)).to_not be_nil
        expect(controller.instance_variable_get(:@responses)).to match_array [response1, response2]
      end
    end

    describe 'create' do
      let(:content) { { 'v1' => 'a', 'v2' => 'c' } }

      it 'should be able to post new results to the api' do
        post :create, params: { uuid: response1.uuid, content: content }
        expect(response.status).to eq 201
      end

      it 'should store the response and update its contents' do
        post :create, params: { uuid: response1.uuid, content: content }
        response1.reload
        expect(response1.content).to_not be_nil
        expect(response1.completed_at).to_not be_nil
        expect(response1.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(response1.content).to_not be_nil
        expect(response1.remote_content).to_not be_nil
        expect(response1.remote_content.content).to_not be_nil
        expect(response1.remote_content.content).to eq content
      end

      it 'should throw a 404 if the response does not exist' do
        post :create, params: { uuid: 'non-exis-tent', content: content }
        expect(response.status).to eq 404
        expect(response.body).to_not be_nil
        expected = { result: 'Response met dat uuid niet gevonden' }.to_json
        expect(response.body).to eq expected
      end

      it 'should throw a 400 if the response has been completed already' do
        post :create, params: { uuid: response1.uuid, content: content }
        post :create, params: { uuid: response1.uuid, content: content }
        expect(response.status).to eq 400
        expected = { result: 'Response met dat uuid heeft al content' }.to_json
        expect(response.body).to eq expected
      end
    end
  end
end
