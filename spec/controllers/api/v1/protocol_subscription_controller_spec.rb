# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    describe ProtocolSubscriptionsController, type: :controller do
      let(:test_response) { FactoryBot.create(:response, completed_at: 10.minutes.ago) }
      let(:protocol_subscription) { test_response.protocol_subscription }
      let(:other_response) { FactoryBot.create(:response) }

      it_should_behave_like 'an is_logged_in concern', :show, id: 0

      describe 'show' do
        describe 'with cookie' do
          before :each do
            cookie_auth(protocol_subscription.person)
          end

          it 'should set the correct env vars if the response is available' do
            get :show, params: { id: protocol_subscription.id }
            expect(response.status).to eq 200
            expect(controller.instance_variable_get(:@protocol_subscription)).to eq(protocol_subscription)
          end

          it 'should render the correct json object' do
            allow(controller).to receive(:render)
              .with(json: protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer)
              .and_call_original
            get :show, params: { id: protocol_subscription.id }
            expect(response.status).to eq 200
          end

          it 'should throw a 403 if the user is not allowed to access' do
            get :show, params: { id: other_response.protocol_subscription.id }
            expect(response.status).to eq 403
            expect(response.body).to eq 'U heeft geen toegang tot deze protocolsubscriptie'
          end

          it 'should throw a 404 if the protocol subscription does not exist' do
            get :show, params: { id: 192_301 }
            expect(response.status).to eq 404
            expect(response.body).to eq 'Protocol subscription met dat ID niet gevonden'
          end
        end

        describe 'without cookie' do
          it 'should return 401 if no protocol_subscription is available' do
            get :show, params: { id: protocol_subscription.id }
            expect(response.status).to eq 401
            expect(response.body).to eq 'Je hebt geen toegang tot deze vragenlijst.'
          end
        end
      end
    end
  end
end
