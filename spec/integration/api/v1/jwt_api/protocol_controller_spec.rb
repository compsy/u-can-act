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

    post 'Creates a new protocol' do
      tags 'Protocols'
      consumes 'application/json'
      produces 'application/json'
      security [JwtAuth: {}]

      parameter name: :protocol, in: :body, schema: {
        type: :object,
        properties: {
          protocol: {
            type: :object,
            properties: {
              name: { type: :string },
              duration: { type: :integer, minimum: 0 },
              invitation_text: { type: :string },
              informed_consent_questionnaire_key: { type: :string },
              questionnaires: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string },
                    measurement: {
                      type: :object ,
                      properties: {
                        open_from_offset: { type: :integer },
                        open_from_day: { type: :string },
                        period: { type: :integer },
                        open_duration: { type: :integer },
                        reminder_delay: { type: :integer },
                        priority: { type: :integer },
                        stop_measurement: { type: :boolean },
                        should_invite: { type: :boolean },
                        only_redirect_if_nothing_else_ready: { type: :boolean }
                      }
                    },
                  }
                }
              }
            },
            required: %i[name duration invitation_text questionnaires]
          }
        }
      }

      let(:protocol) do
        {
          protocol: {
            name: 'a protocol',
            duration: 1,
            invitation_text: 'you have been invited',
            questionnaires: [
              {
                key: 'a_key',
                measurement: {
                  open_from_offset: 0,
                  open_from_day: 'monday',
                  period: 1,
                  open_duration: 1,
                  reminder_delay: 1,
                  priority: 1,
                  stop_measurement: true,
                  should_invite: true,
                  only_redirect_if_nothing_else_ready: true
                }
              }
            ]
          }
        }
      end

      let!(:questionnaire) { FactoryBot.create :questionnaire, key: 'a_key' }

      response '201', 'creates a protocol subscription' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        run_test!
      end

      response '400', 'bad request' do
        let(:Authorization) { "Bearer #{jwt_auth(the_payload, false)}" }
        let(:protocol) do
          {
            protocol: {
              other_attr: 'value'
            }
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
