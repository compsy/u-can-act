# frozen_string_literal: true

require 'swagger_helper'

describe 'ProtocolSubscriptions API' do
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:mentor) { FactoryBot.create(:mentor) }

  path '/basic_auth_api/protocol_subscriptions' do
    post 'Creates a new protocol subscription' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :protocol_subscription, in: :body, schema: {
        type: :object,
        properties: {
          protocol_name: { type: :string },
          auth0_id_string: { type: :string },
          start_date: { type: :string },
          end_date: { type: :string },
          mentor_id: { type: :integer }
        }
      }

      let(:protocol_subscription) do
        {
          protocol_name: protocol.name,
          mentor_id: mentor.id,
          auth0_id_string: auth_user.auth0_id_string
        }
      end

      response '201', 'creates a protocol subscription' do
        let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end

  path '/basic_auth_api/protocol_subscriptions/delegated_protocol_subscriptions' do
    get 'Lists all my students their protocolsubscriptions' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [JwtAuth: {}]

      response '200', 'all delegated protocol subscriptions returned' do
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
