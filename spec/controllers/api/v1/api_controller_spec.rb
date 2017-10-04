# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    describe ApiController, type: :controller do
      controller(ApiController) do
        def index
          render plain: 'Request OK'
        end
      end

      let(:test_response) { FactoryGirl.create(:response) }
      let(:other_response) { FactoryGirl.create(:response) }
      let(:other_person) { FactoryGirl.create(:person) }
      describe 'it should verify if the correct response is available in the session' do
        it 'should return 401 if no response is available' do
          get :index
          expect(response.status).to eq 401
        end

        it 'should set the correct env vars if the response is available' do
          allow(CookieJar).to receive(:read_entry)
            .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                  TokenAuthenticationController::RESPONSE_ID_COOKIE)
            .and_return(test_response.id)

          get :index
          expect(controller.instance_variable_get(:@response)).to eq(test_response)
          expect(controller.instance_variable_get(:@current_user)).to eq(test_response.protocol_subscription.person)
          expect(response.status).to eq 200
        end
      end

      describe 'check_access_allowed' do
        before :each do
          controller.instance_variable_set(:@response, test_response)
          controller.instance_variable_set(:@current_user, test_response.protocol_subscription.person)
        end

        it 'should return true if the protocol subscription is mine' do
          expect(controller.check_access_allowed(test_response.protocol_subscription)).to be_truthy
        end
        it 'should return true if the protocol subscription is of my student' do
          current_person = test_response.protocol_subscription.person
          test_response.protocol_subscription.update_attributes!(filling_out_for: current_person, person: other_person)
          controller.instance_variable_set(:@response, test_response)
          expect(controller.check_access_allowed(test_response.protocol_subscription)).to be_truthy
        end
        it 'should return false otherwise' do
          expect(controller.check_access_allowed(other_response.protocol_subscription)).to be_falsey
        end
      end
    end
  end
end
