# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionnaireController, type: :controller do
  describe 'GET /' do
    it 'shows status 200 when everything is correct' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(200)
      expect(response).to render_template('questionnaire/show')
    end
    it 'should show an informed questionnaire if there is one required' do
      protocol = FactoryGirl.create(:protocol, :with_informed_consent_questionnaire)
      expect(protocol.informed_consent_questionnaire).not_to be_nil
      expect(protocol.informed_consent_questionnaire.title).to eq 'Informed Consent'
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(200)
      expect(response).to render_template('questionnaire/informed_consent')
    end
  end
  describe 'POST /' do
    it 'requires a response id' do
      post :create
      expect(response).to have_http_status(401)
      expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
    end
    it 'requires a response that exists' do
      expect_any_instance_of(described_class).to receive(:verify_response_id)
      post :create, params: { response_id: 'something', content: { 'v1' => 'true' } }
      expect(response).to have_http_status(404)
      expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
    end
    it 'requires a response that is not filled out yet' do
      responseobj = FactoryGirl.create(:response, :completed)
      FactoryGirl.create(:invitation_token, response: responseobj)
      expect_any_instance_of(described_class).to receive(:verify_response_id)
      post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
    end
    it 'requires a q parameter that is not expired' do
      responseobj = FactoryGirl.create(:response)
      expect_any_instance_of(described_class).to receive(:verify_response_id)
      post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
    end
    it 'shows status 200 when everything is correct' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      expect_any_instance_of(described_class).to receive(:verify_response_id)
      FactoryGirl.create(:invitation_token, response: responseobj)
      post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
      expect(response).to have_http_status(302)
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to eq('v1' => 'true')
    end

    it 'should save the response in the database, with the correct timestamp' do
      person_type = :student
      person = FactoryGirl.create(person_type)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 person: person)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)

      date = Time.zone.now
      Timecop.freeze(date)
      expect(responseobj.opened_at).to be_nil
      get :show, params: { q: invitation_token.token }
      responseobj.reload
      expect(responseobj.opened_at).to be_within(5.seconds).of(date)
      Timecop.return
    end

    describe 'redirecting with mentor' do
      let(:protocol_subscription) do
        FactoryGirl.create(:protocol_subscription,
                           start_date: 1.week.ago.at_beginning_of_day)
      end
      let(:responseobj) do
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 1.hour.ago)
      end
      before :each do
        expect_any_instance_of(described_class).to receive(:verify_response_id)
        FactoryGirl.create(:invitation_token, response: responseobj)
      end

      it 'should render the klaar page if the person is a student' do
        expect(CookieJar).to receive(:mentor?).and_return(false)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq klaar_url
      end

      it 'should redirect to the mentor overview page if the person is a mentor' do
        expect(CookieJar).to receive(:mentor?).and_return(true)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq mentor_overview_index_url
      end
    end
  end
end
