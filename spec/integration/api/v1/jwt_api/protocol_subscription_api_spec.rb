# frozen_string_literal: true

require 'swagger_helper'

describe 'ProtocolSubscription api' do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:auth0_id_string) { the_auth_user.auth0_id_string }
  let(:protocol_subscriptions) { FactoryBot.create_list(:protocol_subscription, 3, person: auth_user.person) }
  let(:protocol_subscriptions_other) { FactoryBot.create_list(:protocol_subscription, 5, :mentor, person: auth_user.person) }
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
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'all my protocol subscriptions returned' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   person_type: { type: :string },
                   protocol_completion: { type: :integer },
                   earned_euros: { type: :integer },
                   max_still_awardable_euros: { type: :integer },
                   euro_delta: { type: :integer },
                   current_multiplier: { type: :integer },
                   max_streak: { type: :integer },
                   initial_multiplier: { type: :integer }
                 }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test! do |response|
          result = JSON.parse(response.body)
          expect(result.length).to eq 3
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
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'all my protocol subscriptions returned' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   person_type: { type: :string },
                   protocol_completion: { type: :integer },
                   earned_euros: { type: :integer },
                   max_still_awardable_euros: { type: :integer },
                   euro_delta: { type: :integer },
                   current_multiplier: { type: :integer },
                   max_streak: { type: :integer },
                   initial_multiplier: { type: :integer }
                 }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test! do |response|
          result = JSON.parse(response.body)
          expect(result.length).to eq 5
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
