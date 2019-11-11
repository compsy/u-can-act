# frozen_string_literal: true

require 'swagger_helper'

describe 'ProtocolSubscription api' do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:auth0_id_string) { the_auth_user.auth0_id_string }
  let!(:protocol_subscriptions) { FactoryBot.create_list(:protocol_subscription, 3, person: the_auth_user.person) }
  let!(:protocol_subscriptions_other) { FactoryBot.create_list(:protocol_subscription, 5, :mentor, person: the_auth_user.person) }
  let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Demo-team') }
  let!(:the_payload) do
    {
      'sub' => auth0_id_string,
      ENV['SITE_LOCATION'] => {
        'access_level' => ['user']
      }
    }
  end
  path '/protocol_subscriptions/mine' do
    get 'Lists all my protocolsubscriptions' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [JwtAuth: {}]

      response '200', 'all my protocol subscriptions returned' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   person_type: { type: :string },
                   protocol_completion: { type: :array },
                   earned_euros: { type: :number },
                   max_still_awardable_euros: { type: :number },
                   euro_delta: { type: :number },
                   current_multiplier: { type: :number },
                   max_streak: { type: :null },
                   initial_multiplier: { type: :number }
                 }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test! do |response|
          result = JSON.parse(response.body)
          expect(result.length).to eq protocol_subscriptions.length
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end

  path '/protocol_subscriptions/delegated_protocol_subscriptions' do
    get 'Lists all my students their protocolsubscriptions' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [JwtAuth: {}]

      response '200', 'all my protocol subscriptions returned' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   person_type: { type: :string },
                   protocol_completion: { type: :array },
                   earned_euros: { type: :number },
                   max_still_awardable_euros: { type: :number },
                   euro_delta: { type: :number },
                   current_multiplier: { type: :number },
                   max_streak: { type: :null },
                   initial_multiplier: { type: :number }
                 }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test! do |response|
          result = JSON.parse(response.body)
          expect(result.length).to eq protocol_subscriptions_other.length
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
