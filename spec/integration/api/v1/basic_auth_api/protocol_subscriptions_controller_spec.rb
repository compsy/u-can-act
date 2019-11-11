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
end
