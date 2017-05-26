# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentorOverviewController, type: :controller do
  let(:student) { FactoryGirl.create(:student) }
  let(:mentor) { FactoryGirl.create(:mentor) }
  describe 'GET #index' do
    describe 'Error checking' do
      it 'requires a token with person id that exists' do
        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), TokenAuthenticationController::PERSON_ID_COOKIE)
          .and_return(nil)
        get :index
        expect(response).to have_http_status(404)
        expect(response.body).to include('Het persoon kon niet gevonden worden')
      end
    end

    describe 'with a correct call', focus: true do
      before :each do
        [mentor, student].each do |person_to_fill_out_for|
          protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                     start_date: 1.week.ago.at_beginning_of_day,
                                                     person: mentor,
                                                     filling_out_for: person_to_fill_out_for)
          FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        end

        expect(CookieJar).to receive(:read_entry)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), TokenAuthenticationController::PERSON_ID_COOKIE)
          .and_return(mentor.id)

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
