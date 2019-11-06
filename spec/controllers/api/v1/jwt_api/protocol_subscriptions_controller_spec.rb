# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::ProtocolSubscriptionsController, type: :controller do
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
  let(:team) { FactoryBot.create(:team, :with_roles) }

  let!(:the_payload) do
    { ENV['SITE_LOCATION'] => {
      'access_level' => ['user'],
      'team' => team.name
    } }
  end
  it_behaves_like 'a jwt authenticated route', 'get', :mine

  describe 'mine' do
    describe 'with jwt token' do
      before do
        the_payload[:sub] = the_auth_user.auth0_id_string
        jwt_auth the_payload
      end

      it 'returns all my protocol subscriptions' do
        get :mine
        expect(response.status).to eq 200
        expect(JSON.parse(response.body).length).to eq 4 + 1
      end
    end
  end
end
