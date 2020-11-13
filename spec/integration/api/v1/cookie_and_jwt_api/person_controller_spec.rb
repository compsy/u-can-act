# frozen_string_literal: true

require 'swagger_helper'

describe 'Person API' do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:auth0_id_string) { the_auth_user.auth0_id_string }
  let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Demo-team') }
  let!(:the_payload) do
    {
      'sub' => auth0_id_string,
      ENV['SITE_LOCATION'] => {
        'access_level' => ['user']
      }
    }
  end

  before :each do
    the_auth_user.person.update!(
      first_name: 'abc',
      last_name: 'def',
      gender: 'male',
      email: 'male@male.com',
      mobile_phone: '0612341234'
    )
  end

  path '/person' do
    put 'Updates the current user' do
      tags 'Person'
      consumes 'application/json'
      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: {
          mobile_phone: { type: :string },
          email: { type: :string },
          timestamp: { type: :string }
        }
      }
      security [JwtAuth: {}]

      let(:person) do
        { person: {
          email: 'test@example.com', mobile_phone: '0612341234'
        } }
      end

      response '200', 'updates the current user' do
        schema type: :object,
               properties: {
                 first_name: { type: :string },
                 last_name: { type: :string },
                 gender: { type: :string },
                 email: { type: :string },
                 mobile_phone: { type: :string },
                 timestamp: { type: :string }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test!
      end

      response '200', 'updates the current user if later timestamp is given' do
        schema type: :object,
               properties: {
                 first_name: { type: :string },
                 last_name: { type: :string },
                 gender: { type: :string },
                 email: { type: :string },
                 mobile_phone: { type: :string },
                 timestamp: { type: :string }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        let(:person) do
          { person: {
            email: 'test@example.com',
            mobile_phone: '0612341234',
            timestamp: (Time.current + 1.minute).to_s
          } }
        end

        run_test!
      end

      response '422', 'does not update the current user if older timestamp is given' do
        schema type: :object,
               properties: {
                 first_name: { type: :string },
                 last_name: { type: :string },
                 gender: { type: :string },
                 email: { type: :string },
                 mobile_phone: { type: :string },
                 timestamp: { type: :string }
               }
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        let(:person) do
          { person: {
            email: 'test@example.com',
            mobile_phone: '0612341234',
            timestamp: (Time.current - 1.minute).to_s
          } }
        end

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end

  path '/person/me' do
    get 'Gets the current person' do
      tags 'Person'
      consumes 'application/json'
      security [JwtAuth: {}]

      response '200', 'returns the current person' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        schema type: :object,
               properties: {
                 first_name: { type: :string },
                 last_name: { type: :string },
                 gender: { type: :string },
                 email: { type: :string },
                 mobile_phone: { type: :string }
               }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
