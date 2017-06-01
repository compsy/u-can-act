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
        responseobj = FactoryGirl.create(:response, :completed)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
      end

      it 'should not require a response not to be filled out if the user is heading for the mentor page' do
        mentor = FactoryGirl.create(:mentor)
        student = FactoryGirl.create(:student)
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: mentor,
                                                   filling_out_for: student)
        responseobj = FactoryGirl.create(:response, :completed, protocol_subscription: protocol_subscription)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        expect(controller).to receive(:redirect_to_questionnaire).with(mentor.type,
                                                                       invitation_token.token).and_call_original
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(302)
      end

      it 'should require a q parameter that is not expired' do
        invitation_token = FactoryGirl.create(:invitation_token)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
      end

      it 'should give an error when not given a mentor or student' do
        person_type = :person
        person = FactoryGirl.create(person_type)
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: person)
        responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription,
                                                    open_from: 1.hour.ago)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(404)
        expect(response.body).to include('De code die opgegeven is hoort niet bij een student of mentor.')
      end
    end

    describe 'redirects to the correct page' do
      it 'should redirect to the questionnaire controller if the person is a student' do
        person_type = :student
        person = FactoryGirl.create(person_type)
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: person)
        responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription,
                                                    open_from: 1.hour.ago)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(questionnaire_url(q: invitation_token.token))
      end

      it 'should redirect to the mentor controller if the person is a mentor' do
        person_type = :mentor
        person = FactoryGirl.create(person_type)
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: person)
        responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription,
                                                    open_from: 1.hour.ago)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(302)
        expect(response.location).to eq(mentor_overview_index_url)
      end
    end

    describe 'should set the correct cookie' do
      let(:person_type) { :mentor }
      let(:person) { FactoryGirl.create(person_type) }
      let(:protocol_subscription) do
        FactoryGirl.create(:protocol_subscription,
                           start_date: 1.week.ago.at_beginning_of_day,
                           person: person)
      end
      let(:responseobj) do
        FactoryGirl.create(:response, protocol_subscription: protocol_subscription,
                                      open_from: 1.hour.ago)
      end
      let(:invitation_token) { FactoryGirl.create(:invitation_token, response: responseobj) }

      it 'should set the response id cookie' do
        expected = {
          person_id: person.id.to_s,
          response_id: responseobj.id.to_s,
          type: person.type.to_s
        }
        expect(CookieJar)
          .to receive(:set_or_update_cookie)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), expected)
        get :show, params: { q: invitation_token.token }
      end
    end
  end
end
