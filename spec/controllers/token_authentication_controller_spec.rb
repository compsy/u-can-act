# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenAuthenticationController, type: :controller do
  describe 'GET #show' do
    describe 'Error checking' do
      it 'should return http not found when not given any params' do
        get :show
        expect(response).to have_http_status(404)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end

      it 'should require a q parameter that exists' do
        get :show, params: { q: 'something' }
        expect(response).to have_http_status(404)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end

      it 'should require a response that is not filled out yet' do
        responseobj = FactoryBot.create(:response, :completed)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
      end

      it 'should not require a response not to be filled out if the user is heading for the mentor page' do
        mentor = FactoryBot.create(:mentor)
        student = FactoryBot.create(:student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: mentor,
                                                  filling_out_for: student)
        responseobj = FactoryBot.create(:response, :completed, protocol_subscription: protocol_subscription)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)
        expect(controller).to receive(:redirect_to_questionnaire).with(protocol_subscription.for_myself?,
                                                                       responseobj.uuid).and_call_original
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(302)
      end

      it 'should require a q parameter that is not expired' do
        responseobj = FactoryBot.create(:response, :invite_sent)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)

        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
      end
    end

    describe 'redirects to the correct page' do
      it 'should redirect to the questionnaire controller if the person is a student' do
        person_type = :student
        person = FactoryBot.create(person_type)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person)
        responseobj = FactoryBot.create(:response,
                                        :invite_sent,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(questionnaire_url(uuid: responseobj.uuid))
      end

      it 'should redirect to the questionnaire controller for a mentor filling out a questionnaire for themselves' do
        person_type = :mentor
        person = FactoryBot.create(person_type)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person)
        responseobj = FactoryBot.create(:response, :invite_sent, protocol_subscription: protocol_subscription,
                                                                  open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(questionnaire_url(uuid: responseobj.uuid))
      end

      it 'should redirect to the mentor controller for a mentor filling out a questionnaire for someone else' do
        person_type = :mentor
        person = FactoryBot.create(person_type)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person,
                                                  filling_out_for: FactoryBot.create(:student))
        responseobj = FactoryBot.create(:response, :invite_sent, protocol_subscription: protocol_subscription,
                                                                  open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, response: responseobj)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(302)
        expect(response.location).to eq(mentor_overview_index_url)
      end
    end

    describe 'should set the correct cookie' do
      let(:person_type) { :mentor }
      let(:person) { FactoryBot.create(person_type) }
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: person)
      end
      let(:responseobj) do
        FactoryBot.create(:response,
                          :invite_sent,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago)
      end
      let(:invitation_token) { FactoryBot.create(:invitation_token, response: responseobj) }

      it 'should set the response id cookie' do
        expected = { response_id: responseobj.id.to_s }
        expect(CookieJar)
          .to receive(:set_or_update_cookie)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), expected)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
      end
    end
  end
end
