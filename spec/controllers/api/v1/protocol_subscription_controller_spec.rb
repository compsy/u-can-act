# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    describe ProtocolSubscriptionsController, type: :controller do
      let(:test_response) { FactoryGirl.create(:response, completed_at: 10.minutes.ago) }
      let(:other_response) { FactoryGirl.create(:response) }
      describe 'show' do
        describe 'with cookie' do
          before :each do
            allow(CookieJar).to receive(:read_entry)
              .with(instance_of(ActionDispatch::Cookies::SignedCookieJar),
                    TokenAuthenticationController::RESPONSE_ID_COOKIE)
              .and_return(test_response.id)
          end
          it 'should render the correct json object' do
            allow(controller).to receive(:render)
              .with(json: test_response.protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer)
              .and_call_original
            get :show, params: { id: test_response.protocol_subscription.id }
            expect(response.status).to eq 200
          end

          it 'should throw a 403 if the user is not allowed to access' do
            get :show, params: { id: other_response.protocol_subscription.id }
            expect(response.status).to eq 403
            expect(response.body).to eq 'You are not allowed to access this protocol subscription!'
          end

          it 'should throw a 404 if the protocol subscription does not exist' do
            get :show, params: { id: 192_301 }
            expect(response.status).to eq 404
            expect(response.body).to eq 'Protocol subscription with that id not found'
          end
        end

        describe 'without cookie' do
          it 'should throw a 401 if the cookie is not set properly' do
            get :show, params: { id: test_response.protocol_subscription.id }
            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
