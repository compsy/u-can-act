# frozen_string_literal: true

require 'swagger_helper'

describe 'AuthUser API' do
  path '/auth_user' do
    let(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:auth0_id_string) { 'some-auth0-id' }
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Demo-team') }
    let!(:the_payload) do
      {
        'sub' => auth0_id_string,
        ENV.fetch('SITE_LOCATION', nil) => {
          'access_level' => ['user']
        }
      }
    end

    post 'Creates an auth user' do
      tags 'Auth user'
      consumes 'application/json'
      security [JwtAuth: {}]

      response '200', 'auth user created' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
