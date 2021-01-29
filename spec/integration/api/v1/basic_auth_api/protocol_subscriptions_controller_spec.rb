# frozen_string_literal: true

require 'swagger_helper'

describe 'ProtocolSubscriptions API' do
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:other_person) { FactoryBot.create(:person) }
  let(:mentor) { FactoryBot.create(:mentor) }
  let!(:the_payload) do
    {
      'sub' => auth_user.auth0_id_string,
      ENV['SITE_LOCATION'] => {
        'access_level' => ['user']
      }
    }
  end

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

  path '/basic_auth_api/protocol_subscriptions/{id}' do
    patch 'Updates a protocol subscription' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :id, in: :path, type: :string
      parameter name: :query, in: :body, schema: {
        type: :object,
        properties: {
          external_identifier: { type: :string },
          end_date: { type: :string }
        }
      }
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription, external_identifier: 'external_identifier')
      end
      let(:id) { protocol_subscription.id }
      let(:query) do
        {
          external_identifier: 'external_identifier',
          end_date: Time.zone.now.to_s
        }
      end

      response '200', 'cancels a protocol subscription' do
        let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
    delete 'Cancels a protocol subscription' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :id, in: :path, type: :string
      parameter name: :external_identifier, in: :body, schema: {
        type: :object,
        properties: {
          external_identifier: { type: :string }
        }
      }
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription, external_identifier: 'external_identifier')
      end
      let(:id) { protocol_subscription.id }
      let(:external_identifier) do
        {
          external_identifier: 'external_identifier'
        }
      end

      response '200', 'cancels a protocol subscription' do
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
      security [BasicAuth: {}]
      parameter name: :external_identifier, in: :query, type: :string
      let(:external_identifier) { 'external_identifier' }

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
                   initial_multiplier: { type: :number },
                   start_date: { type: :string },
                   end_date: { type: :string },
                   name: { type: :string },
                   questionnaires: { type: :array },
                   first_name: { type: :string },
                   auth0_id_string: { type: :string },
                   id: { type: :integer },
                   state: { type: :string }
                 }
               }
        let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        let!(:protocol_subscriptions) do
          FactoryBot.create_list(:protocol_subscription, 3,
                                 person: auth_user.person,
                                 external_identifier: 'something_else')
        end
        let!(:protocol_subscriptions_other) do
          FactoryBot.create_list(:protocol_subscription, 5,
                                 filling_out_for_id: auth_user.person.id,
                                 external_identifier: 'external_identifier')
        end

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

  path '/basic_auth_api/protocol_subscriptions/destroy_delegated_protocol_subscriptions' do
    delete 'Cancels all protocol subscriptions with a certain external identifier for a user' do
      tags 'ProtocolSubscription'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :query, in: :body, schema: {
        type: :object,
        properties: {
          auth0_id_string: { type: :string },
          external_identifier: { type: :string }
        }
      }
      let(:auth_user) { FactoryBot.create(:auth_user) }
      let(:person) { FactoryBot.create(:person, auth_user: auth_user) }
      let!(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription, external_identifier: 'external_identifier', person: person)
      end
      let(:query) do
        {
          external_identifier: 'external_identifier',
          auth0_id_string: auth_user.auth0_id_string
        }
      end

      response '200', 'cancels protocol subscriptions' do
        let(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        run_test!
      end

      response '422', 'external identifier not given' do
        let(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        let(:query) do
          {
            auth0_id_string: auth_user.auth0_id_string
          }
        end
        run_test!
      end

      response '404', 'person not found' do
        let(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        let(:query) do
          {
            external_identifier: 'external_identifier'
          }
        end
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
