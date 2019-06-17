# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ResponseController, type: :controller do
  let!(:person) { FactoryBot.create(:person) }
  let!(:response1) { FactoryBot.create(:response, :not_expired, open_from: 10.minutes.ago) }
  let!(:response2) { FactoryBot.create(:response, :not_expired, open_from: 8.minutes.ago) }
  let!(:response3) { FactoryBot.create(:response, :future) }
  let!(:response4) { FactoryBot.create(:response, :completed) }

  before do
    response1.protocol_subscription.update!(
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

  describe 'show should be authenticated' do
    let(:params) { { uuid: response1.uuid } }

    it_behaves_like 'a basic authenticated route', 'get', :show
  end

  describe 'index should be authenticated' do
    let(:params) { { external_identifier: person.external_identifier } }

    it_behaves_like 'a basic authenticated route', 'get', :index
  end

  describe 'create should be authenticated' do
    let(:params) { { uuid: response2.uuid } }

    it_behaves_like 'a basic authenticated route', 'post', :create
  end

  describe 'authenticated' do
    before do
      basic_api_auth name: ENV['API_KEY'], password: ENV['API_SECRET']
    end

    describe 'show' do
      it 'heads a 200' do
        get :show, params: { uuid: response1.uuid }
        expect(response.status).to eq 200
      end

      it 'renders the response json belonging to the uuid' do
        get :show, params: { uuid: response1.uuid }
        expect(response.header['Content-Type']).to include 'application/json'

        expect(response.body).not_to be_nil
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['uuid']).to eq response1.uuid
        expect(json['questionnaire_title']).to eq response1.measurement.questionnaire.title
        expect(json['questionnaire_content']).not_to be_nil
        expect(json['questionnaire_content'].as_json)
          .to eq(response1.measurement.questionnaire.content.as_json)
      end

      it 'uses the PersonalizedQuestionnaireSerializer for rendering' do
        allow(controller).to receive(:render)
          .with(json: response1, serializer: Api::PersonalizedQuestionnaireSerializer)
          .and_call_original
        get :show, params: { uuid: response1.uuid }
      end

      it 'renders a 404 if the requested uuid is not found' do
        get :show, params: { uuid: 'non-exis-tent' }
        expect(response.status).to eq 404
        expect(response.body).not_to be_nil
        expect(response.body).to eq 'Response met dat uuid niet gevonden'
      end

      it 'sets the correct instance variables' do
        get :show, params: { uuid: response1.uuid }
        expect(controller.instance_variable_get(:@response)).not_to be_nil
        expect(controller.instance_variable_get(:@response)).to eq response1
      end
    end

    describe 'index' do
      it 'heads a 200' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(response.status).to eq 200
      end

      it 'lists all open questionnairs that belong to the current user' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(response.header['Content-Type']).to include 'application/json'

        expect(response.body).not_to be_nil
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        [response1, response2].each_with_index do |resp, index|
          expect(json[index]['uuid']).to eq(resp.uuid)
          expect(json[index]['questionnaire']['key']).to eq(resp.measurement.questionnaire.key)
          expect(json[index]['questionnaire']['title']).to eq(resp.measurement.questionnaire.title)
        end
      end

      it 'uses the ResponseSerializer for rendering' do
        allow(controller).to receive(:render)
          .with(json: [response1, response2], each_serializer: Api::ResponseSerializer)
          .and_call_original
        get :index, params: { external_identifier: person.external_identifier }
      end

      it 'renders a 404 if the requested person is not found' do
        get :index, params: { external_identifier: 'wrong' }
        expect(response.status).to eq 404
        expect(response.body).not_to be_nil
        expect(response.body).to eq 'Persoon met die external_identifier niet gevonden'
      end

      it 'sets the correct instance variables' do
        get :index, params: { external_identifier: person.external_identifier }
        expect(controller.instance_variable_get(:@responses)).not_to be_nil
        expect(controller.instance_variable_get(:@responses)).to match_array [response1, response2]
      end
    end

    describe 'create' do
      let(:content) { { 'v1' => 'a', 'v2' => 'c' } }
      let(:the_response) { FactoryBot.create(:response, content: nil) }

      it 'is able to post new results to the api' do
        post :create, params: { uuid: the_response.uuid, content: content }
        expect(response.status).to eq 201
      end

      it 'stores the response and update its contents' do
        post :create, params: { uuid: the_response.uuid, content: content }
        the_response.reload
        expect(the_response.content).not_to be_nil
        expect(the_response.completed_at).not_to be_nil
        expect(the_response.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(the_response.content).not_to be_nil
        expect(the_response.remote_content).not_to be_nil
        expect(the_response.remote_content.content).not_to be_nil
        expect(the_response.remote_content.content).to eq content
      end

      it 'throws a 404 if the response does not exist' do
        post :create, params: { uuid: 'non-exis-tent', content: content }
        expect(response.status).to eq 404
        expect(response.body).not_to be_nil
        expect(response.body).to eq 'Response met dat uuid niet gevonden'
      end

      it 'throws a 400 if the response has been completed already' do
        post :create, params: { uuid: the_response.uuid, content: content }
        post :create, params: { uuid: the_response.uuid, content: content }
        expect(response.status).to eq 400
        expect(response.body).to eq 'Response met dat uuid heeft al content'
      end
    end
  end
end
