# frozen_string_literal: true

require 'swagger_helper'

describe 'Protocol api' do
  path '/protocol' do
    let(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:auth0_id_string) { 'some-auth0-id' }
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Demo-team') }
    let!(:the_payload) do
      {
        'sub' => auth0_id_string,
        ENV['SITE_LOCATION'] => {
          'access_level' => ['user']
        }
      }
    end
    let!(:protocol) { FactoryBot.create(:protocol) }

    get 'Lists all protocols' do
      tags 'Protocols'
      consumes 'application/json'
      produces 'application/json'
      security [JwtAuth: {}]

      response '200', 'lists all protocols' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   name: { type: :string },
                   duration: { type: :datetime },
                   created_at: { type: :datetime },
                   updated_at: { type: :datetime },
                   informed_consent_questionnaire_id: { type: %i[integer null] },
                   invitation_text: { type: %i[string null] }
                 }
               }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end

  path '/protocol/{id}/preview' do
    let(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:auth0_id_string) { 'some-auth0-id' }
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Demo-team') }
    let!(:the_payload) do
      {
        'sub' => auth0_id_string,
        ENV['SITE_LOCATION'] => {
          'access_level' => ['user']
        }
      }
    end
    let!(:protocol) { FactoryBot.create(:protocol) }

    post 'Preview a protocol' do
      tags 'Protocols'
      consumes 'application/json'
      produces 'application/json'
      security [JwtAuth: {}]

      parameter name: :id, in: :path, type: :string, description: 'Name of the protocol to preview'
      let!(:id) { protocol.name }

      response '200', 'preview a protocol' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   open_from: { type: :datetime, description: 'The open_from date of the response' },
                   questionnaire: { type: :string, description: 'The key of the questionnaire' }
                 }
               }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end

      response '404', 'no protocol found by that name' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        let!(:id) { 'unknown-protocol-name' }
        run_test!
      end
    end
  end
end
