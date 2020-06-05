# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionnaireController, type: :controller do
  render_views
  let(:person) { FactoryBot.create(:person) }
  let(:mentor) { FactoryBot.create(:mentor) }
  let(:student) { FactoryBot.create(:student) }

  describe 'GET /' do
    describe 'redirects to the correct page' do
      it 'redirects to the questionnaire controller if the person is a student' do
        cookie_auth(student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        responseobj = FactoryBot.create(:response,
                                        :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(:found)
        expect(response.location).not_to end_with(mentor_overview_index_path)
        expect(response.location).to end_with(questionnaire_path(uuid: responseobj.uuid))
      end

      it 'redirects to the klaar page if the person is a student but the questionnaire was completed' do
        cookie_auth(student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        FactoryBot.create(:response,
                          :completed,
                          :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(:found)
        expect(response.location).not_to end_with(mentor_overview_index_path)
        expect(response.location).to end_with(klaar_path)
      end

      it 'redirects to the questionnaire controller for a mentor filling out a questionnaire for themselves' do
        cookie_auth(mentor)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: mentor)
        responseobj = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                             open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(:found)
        expect(response.location).not_to eq(mentor_overview_index_path)
        expect(response.location).to end_with(questionnaire_path(uuid: responseobj.uuid))
      end

      it 'redirects to the mentor controller for a mentor filling out a questionnaire for someone else' do
        cookie_auth(mentor)
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: mentor,
                          filling_out_for: FactoryBot.create(:student))
        get :index
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with(mentor_overview_index_path)
      end
    end
  end

  describe 'GET /:uuid' do
    xdescribe 'with jwt auth' do
      it 'should be tested' do
      end
    end

    describe 'with cookie auth' do
      before do
        cookie_auth(person)
      end

      it 'shows status 200 when everything is correct' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        get :show, params: { uuid: responseobj.uuid }
        expect(response).to have_http_status(200)
        expect(response).to render_template('questionnaire/show')
      end

      it 'shows an informed questionnaire if there is one required' do
        protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire)
        expect(protocol.informed_consent_questionnaire).not_to be_nil
        expect(protocol.informed_consent_questionnaire.title).to eq 'Informed Consent'
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person,
                                                  protocol: protocol)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        get :show, params: { uuid: responseobj.uuid }
        expect(response).to have_http_status(200)
        expect(response).to render_template('questionnaire/informed_consent')
      end

      it 'saves the response in the database, with the correct timestamp' do
        cookie_auth(mentor)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: mentor,
                                                  filling_out_for: person)
        responseobj = FactoryBot.create(:response,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        date = Time.zone.now
        Timecop.freeze(date)
        expect(responseobj.opened_at).to be_nil
        get :show, params: { uuid: responseobj.uuid }
        expect(response.status).to eq 200
        responseobj.reload
        expect(responseobj.opened_at).to be_within(5.seconds).of(date)
        Timecop.return
      end
    end
  end

  describe 'the @is_mentor_variable' do
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        start_date: 1.week.ago.at_beginning_of_day,
                        protocol: protocol)
    end
    let(:responseobj) do
      FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                   open_from: 1.hour.ago)
    end

    # let(:invitation_token) { FactoryBot.create(:invitation_token, response: responseobj) }
    it 'sets it to true when the current person is a mentor' do
      cookie_auth(mentor)
      protocol_subscription.update!(person: mentor)
      get :show, params: { uuid: responseobj.uuid }
      expect(assigns(:use_mentor_layout)).not_to be_nil
      expect(assigns(:use_mentor_layout)).to be_truthy
    end

    it 'sets it to false when the current person is a student' do
      cookie_auth(student)
      protocol_subscription.update!(person: student)
      get :show, params: { uuid: responseobj.uuid }
      expect(assigns(:use_mentor_layout)).not_to be_nil
      expect(assigns(:use_mentor_layout)).to be_falsey
    end
  end

  describe 'DELETE' do
    describe 'with jwt auth' do
      it 'should be tested' do
      end
    end
    describe 'with cookie auth' do
      describe 'unsubscribing from a protocol' do
        before do
          cookie_auth(student)
        end

        let!(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            start_date: 1.week.ago.at_beginning_of_day,
                            person: student)
        end
        let!(:responseobj) do
          FactoryBot.create(:response,
                            open_from: 1.hour.ago,
                            protocol_subscription: protocol_subscription)
        end

        it 'stops the protocol subscription' do
          expect(responseobj.protocol_subscription.state).to eq(ProtocolSubscription::ACTIVE_STATE)
          delete :destroy, params: { uuid: responseobj.uuid }
          responseobj.protocol_subscription.reload
          expect(responseobj.protocol_subscription.state).to eq(ProtocolSubscription::CANCELED_STATE)
        end

        it 'redirects to the correct page' do
          delete :destroy, params: { uuid: responseobj.uuid }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('Bedankt voor je inzet!')
        end

        it 'redirects to the correct stop measurement if one is available' do
          protocol_subscription = responseobj.protocol_subscription
          protocol = protocol_subscription.protocol
          stop_measurement = FactoryBot.create(:measurement, :stop_measurement, protocol: protocol)
          stop_response = FactoryBot.create(:response,
                                            :not_expired,
                                            measurement: stop_measurement)
          protocol_subscription.responses << stop_response
          protocol_subscription.save!
          expect(protocol_subscription.responses.length).to eq 2
          delete :destroy, params: { uuid: responseobj.uuid }
          query = URI.parse(response.location).path.split('/').last

          expect(response).to have_http_status(:found)
          expect(query).to eq stop_response.uuid
          expect(protocol_subscription.stop_response.uuid).to eq stop_response.uuid
        end
      end
    end
  end

  describe 'POST /' do
    describe 'redirecting with a student' do
      before do
        cookie_auth(student)
      end

      it 'requires a response id' do
        post :create
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
      end

      it 'requires a response that exists' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: 'something', content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end

      it 'requires a response that is not filled out yet' do
        responseobj = FactoryBot.create(:response, :completed)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with klaar_path
      end

      it 'requires a q parameter that is not expired' do
        responseobj = FactoryBot.create(:response)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with klaar_path
      end

      it 'shows status 200 when everything is correct' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago,
                                        opened_at: 5.minutes.ago)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:found)
        responseobj.reload
        expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(responseobj.content).not_to be_nil
        expect(responseobj.values).to eq('v1' => 'true')
      end

      it 'refuses to store empty responses' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago,
                                        opened_at: 5.minutes.ago)
        post :create, params: { response_id: responseobj.id, content: {} }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include 'Cannot store blank questionnaire responses'
        responseobj.reload
        expect(responseobj.completed_at).to be_blank
        expect(responseobj.content).to be_blank
        expect(responseobj.values).to be_blank
      end

      it 'refuses to store responses with just the csrf_failed key' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago,
                                        opened_at: 5.minutes.ago)
        post :create, params: { response_id: responseobj.id, content: { 'csrf_failed' => true } }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include 'Cannot store blank questionnaire responses'
        responseobj.reload
        expect(responseobj.completed_at).to be_blank
        expect(responseobj.content).to be_blank
        expect(responseobj.values).to be_blank
      end

      it 'refuses to store responses with blank opened_at' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include 'Cannot accept answers for an unopened response'
        responseobj.reload
        expect(responseobj.completed_at).to be_blank
        expect(responseobj.content).to be_blank
        expect(responseobj.values).to be_blank
      end

      context 'request forgery protection' do
        before do
          ActionController::Base.allow_forgery_protection = true
        end

        after do
          ActionController::Base.allow_forgery_protection = false
        end

        it 'logs an attention message and adds a key to the answers when authenticity token fails' do
          expect_any_instance_of(described_class).to receive(:verify_cookie)
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    start_date: 1.week.ago.at_beginning_of_day)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          open_from: 1.hour.ago,
                                          opened_at: 5.minutes.ago)
          expect(Rails.logger).to receive(:warn).with(/^\[Attention\]/)
          post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
          expect(response).to have_http_status(:found)
          responseobj.reload
          expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
          expect(responseobj.content).not_to be_nil
          expect(responseobj.values).to eq('v1' => 'true', Response::CSRF_FAILED => 'true')
        end

        it 'logs an attention message and adds a key to the answers when authenticity token fails' do
          expect_any_instance_of(described_class).to receive(:verify_cookie)
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    start_date: 1.week.ago.at_beginning_of_day)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          open_from: 1.hour.ago,
                                          opened_at: 5.minutes.ago)
          expect(Rails.logger).to receive(:warn).with(/^\[Attention\]/)
          post :create, params: { response_id: responseobj.id, content: {} }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include 'Cannot store blank questionnaire responses'
          responseobj.reload
          expect(responseobj.completed_at).to be_blank
          expect(responseobj.content).to be_blank
          expect(responseobj.values).to be_blank
        end
      end
    end

    describe 'redirecting with mentor' do
      before do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        cookie_auth(mentor)
      end

      it 'redirects to the mentor overview page if the person is a mentor filling out for him/herself' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor,
                                                                          filling_out_for: mentor,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                   open_from: 1.hour.ago,
                                                   opened_at: 5.minutes.ago)

        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with mentor_overview_index_path
      end

      it 'redirects to the mentor overview page if the person is a mentor filling out for someone else' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor,
                                                                          filling_out_for: student,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                   open_from: 1.hour.ago,
                                                   opened_at: 5.minutes.ago)

        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with mentor_overview_index_path
      end
    end

    context 'saving response in the database' do
      let!(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: mentor,
                          filling_out_for: student)
      end

      let!(:responseobj) do
        FactoryBot.create(:response, :without_filled_out_by_ids,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago,
                          opened_at: 5.minutes.ago)
      end

      before do
        cookie_auth(mentor)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
      end

      it 'saves the response in the database, with the filled out by and for' do
        expect(responseobj.filled_out_by).to be_nil
        expect(responseobj.filled_out_for).to be_nil
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        responseobj.reload
        expect(responseobj.filled_out_by).to eq mentor
        expect(responseobj.filled_out_for).to eq student
      end
    end
  end

  describe 'from_json' do
    it 'should redirect to interactive' do
      post :from_json, params: {}
      expect(response.status).to eq 302
      expect(response.body).to match %r{\/questionnaire\/interactive}
    end
  end

  describe 'interactive_render' do
    context 'correct request' do
      let(:content) do
        { questions: [
          {
            type: :raw,
            content: 'content here!'
          }
        ], scores: [] }.to_json
      end

      it 'heads 200' do
        post :interactive_render, params: { content: content }
        expect(response.status).to eq 200
      end

      it 'returns a HTML version of the passed-in json' do
        expected = '<div class="row section"><div class="col s12">content here!</div></div>'
        post :interactive_render, params: { content: content }
        expect(response.body).to include expected
      end
    end

    context 'wrong request' do
      let(:content) { 'notjson' }

      it 'heads 400 if the content is not an array' do
        post :interactive_render, params: { content: { a: 1 }.to_json }
        expect(response.status).to eq 400
      end

      it 'heads 400' do
        post :interactive_render, params: { content: content }
        expect(response.status).to eq 400
      end

      it 'heads 400 if the json is nil' do
        [{}, { content: [] }].each do |params|
          post :interactive_render, params: params
          expect(response.status).to eq 400
          expect(response.body).to eq({ error: 'Please supply a json string in the content field.' }.to_json)
        end
      end

      it 'heads 400 if the jsoncontent is not a string' do
        post :interactive_render, params: {
          content: [{ "id": 'v1', "title": 'Question', "type": 'radio', "options": %w[1 2] }]
        }
        expect(response.status).to eq 400
        expect(response.body).to eq({ error: 'no implicit conversion of Array into String' }.to_json)
      end

      it 'returns some error message' do
        post :interactive_render, params: { content: content }
        expect(response.body).to eq({ error: "767: unexpected token at 'notjson'" }.to_json)
      end
    end
  end
end
