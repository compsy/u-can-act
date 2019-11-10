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

    get 'Lists all protocols' do
      tags 'Protocols'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'auth user created' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   name: { type: :string },
                   created_at: { type: :datetime },
                   duration: { type: :integer },
                   updated_at: { type: :datetime },
                   invitation_text: { type: :string },
                   informed_consent_questionnaire_id: { type: :integer }
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
end
