# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ProtocolSubscriptionsController, type: :controller do
  render_views
  let(:test_response) { FactoryBot.create(:response, completed_at: 10.minutes.ago) }
  let(:protocol_subscription) { test_response.protocol_subscription }
  let!(:protocol_subscriptions) do
    FactoryBot.create_list(:protocol_subscription, 4, person: protocol_subscription.person)
  end
  let(:other_response) { FactoryBot.create(:response) }

  it_behaves_like 'an is_logged_in concern', :show, id: 0

  describe 'mine' do
    describe 'with cookie' do
      before do
        cookie_auth(protocol_subscription.person)
      end

      fit 'returns all my protocol subscriptions' do
        get :mine
        expect(response.status).to eq 200
        expect(JSON.parse(response.body).length).to eq 4 + 1
      end
    end
  end

  describe 'show' do
    describe 'with cookie' do
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
          .with(json: protocol_subscription, serializer: Api::ProtocolSubscriptionSerializer)
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
        expect(response).to render_template(layout: 'application')
        expect(response.body).to include 'Protocol subscription met dat ID niet gevonden'
      end
    end

    describe 'without cookie' do
      it 'returns 401 if no protocol_subscription is available' do
        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 401
        expect(response).to render_template(layout: 'application')
        expect(response.body).to include 'Je bent niet ingelogd.'
      end
    end
  end
end
