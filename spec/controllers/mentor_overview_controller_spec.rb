# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentorOverviewController, type: :controller do
  let(:student) { FactoryGirl.create(:student) }
  let(:mentor) { FactoryGirl.create(:mentor) }
  describe 'GET #show' do
    describe 'Error checking' do
      it 'requires a q parameter that exists' do
        get :show, params: { q: 'something' }
        expect(response).to have_http_status(404)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end

      it 'requires a response that is not filled out yet' do
        responseobj = FactoryGirl.create(:response, :completed)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
      end

      it 'requires a q parameter that is not expired' do
        invitation_token = FactoryGirl.create(:invitation_token)
        get :show, params: { q: invitation_token.token }
        expect(response).to have_http_status(404)
        expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
      end
    end

    describe 'with a correct call' do
      before :each do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: mentor,
                                                   filling_out_for: student)
        responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)

        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   person: mentor,
                                                   filling_out_for: mentor)
        FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        get :show, params: { q: invitation_token.token }
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
