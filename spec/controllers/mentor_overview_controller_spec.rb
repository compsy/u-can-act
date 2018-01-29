# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentorOverviewController, type: :controller do
  let(:student) { FactoryBot.create(:student) }
  let(:mentor) { FactoryBot.create(:mentor) }
  describe 'GET #index' do
    describe 'Error checking' do
      it 'requires a token with response id that exists' do
        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                TokenAuthenticationController::RESPONSE_ID_COOKIE)
          .and_return(nil)
        get :index
        expect(response).to have_http_status(404)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end
      it 'requires a token with person id that exists and belongs to a Mentor' do
        person = FactoryBot.create(:student)
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: person,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                TokenAuthenticationController::RESPONSE_ID_COOKIE)
          .and_return(responseobj.id)
        get :index
        expect(response).to have_http_status(404)
        expect(response.body).to include('De mentor kon niet gevonden worden.')
      end
      it 'should give status 200 when everything goes correct' do
        person = FactoryBot.create(:mentor)
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: person,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                TokenAuthenticationController::RESPONSE_ID_COOKIE)
          .and_return(responseobj.id)
        get :index
        expect(response).to have_http_status(200)
      end

      describe 'set_mentor' do
        it 'should render a 404 when the current person is not a mentor' do
          person = FactoryBot.create(:student)
          protocol_subscription = FactoryBot.create(:protocol_subscription, person: person,
                                                                            start_date: 1.week.ago.at_beginning_of_day)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          open_from: 1.hour.ago)
          allow(controller).to receive(:set_response).and_return(true)
          controller.instance_variable_set(:@response, responseobj)

          get :index
          expect(response).to have_http_status(404)
          expect(response.body).to include('De mentor kon niet gevonden worden.')
        end

        it 'should set the correct @mentor whenever the person is valid' do
          person = FactoryBot.create(:mentor)
          protocol_subscription = FactoryBot.create(:protocol_subscription, person: person,
                                                                            start_date: 1.week.ago.at_beginning_of_day)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          open_from: 1.hour.ago)
          allow(controller).to receive(:set_response).and_return(true)
          controller.instance_variable_set(:@response, responseobj)

          get :index
          expect(response).to have_http_status(200)
          expect(response.body).to_not include('De mentor kon niet gevonden worden.')
        end
      end
    end

    describe 'with a correct call' do
      before :each do
        some_response = nil
        [mentor, student].each do |person_to_fill_out_for|
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    start_date: 1.week.ago.at_beginning_of_day,
                                                    person: mentor,
                                                    filling_out_for: person_to_fill_out_for)
          some_response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                       open_from: 1.hour.ago)
        end

        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                TokenAuthenticationController::RESPONSE_ID_COOKIE)
          .and_return(some_response.id)

        get :index
      end
      it 'should, given the correct token, set the @mentor' do
        expect(response).to have_http_status(200)
        expect(controller.instance_variable_get(:@mentor)).to eq mentor
      end

      it 'should set the mentor its protocol subscriptions' do
        expect(response).to have_http_status(200)
        prot_sub = controller.instance_variable_get(:@my_protocol_subscriptions)
        expect(prot_sub).to_not be_blank
        expect(prot_sub.length).to eq 1
        prot_sub = prot_sub.first
        expect(prot_sub.filling_out_for).to eq(mentor)
      end

      it 'should set the supervised students protocol subscriptions' do
        expect(response).to have_http_status(200)
        prot_sub = controller.instance_variable_get(:@student_protocol_subscriptions)
        expect(prot_sub).to_not be_blank
        expect(prot_sub.length).to eq 1
        prot_sub = prot_sub.first
        expect(prot_sub.filling_out_for).to eq(student)
      end
    end
  end
end
