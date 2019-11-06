# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CookieAndJwtApi::ProtocolSubscriptionsController, type: :controller do
  render_views
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, person: the_auth_user.person) }
  let(:test_response) do
    FactoryBot.create(:response,
                      protocol_subscription: protocol_subscription,
                      completed_at: 10.minutes.ago)
  end

  let!(:protocol_subscriptions) do
    FactoryBot.create_list(:protocol_subscription, 4, person: protocol_subscription.person)
  end

  let(:other_response) { FactoryBot.create(:response) }

  describe 'show' do
    describe 'without cookie' do
      it 'returns 401 if no protocol_subscription is available' do
        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 401
        expect(response.body).to include 'niet ingelogd'
      end
    end

    describe 'with auth' do
      before do
        cookie_auth(protocol_subscription.person)
      end

      it 'sets the correct env vars if the response is available' do
        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 200
        expect(controller.instance_variable_get(:@protocol_subscription)).to eq(protocol_subscription)
      end

      it 'renders the correct json object' do
        allow(controller).to receive(:render)
          .with(json: protocol_subscription,
                serializer: Api::ProtocolSubscriptionSerializer)
          .and_call_original

        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 200
      end

      it 'throws a 403 if the user is not allowed to access' do
        get :show, params: { id: other_response.protocol_subscription.id }
        expect(response.status).to eq 403
        expect(response.body).to eq 'U heeft geen toegang tot deze protocolsubscriptie'
      end

      it 'throws a 404 if the protocol subscription does not exist' do
        get :show, params: { id: 192_301 }
        expect(response.status).to eq 404
        expect(response.body).to include 'Protocol subscription met dat ID niet gevonden'
      end
    end
  end
end
