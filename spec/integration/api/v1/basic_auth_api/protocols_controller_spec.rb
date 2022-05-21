# frozen_string_literal: true

require 'swagger_helper'

describe 'Protocols API' do
  let(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }

  path '/basic_auth_api/protocols' do
    post 'Creates a new protocol subscription' do
      tags 'Protocols'
      consumes 'application/json'
      produces 'application/json'
      security [BasicAuth: {}]

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
                      type: :object,
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
                    }
                  }
                }
              },
              push_subscriptions: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    url: { type: :string },
                    method: { type: :string }
                  }
                }
              }
            },
            required: %i[name duration invitation_text questionnaires]
          }
        }
      }

      let(:protocol_name) { 'a protocol' }
      let(:questionnaire_key) { 'a_key' }
      let(:push_subscription_name) { 'push-1' }

      let(:protocol) do
        {
          protocol: {
            name: protocol_name,
            duration: 1,
            invitation_text: 'you have been invited',
            questionnaires: [
              {
                key: questionnaire_key,
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
            ],
            push_subscriptions: [
              {
                name: push_subscription_name,
                url: 'http://localhost:6000',
                method: 'POST'
              }
            ]
          }
        }
      end

      let!(:questionnaire) { FactoryBot.create :questionnaire, key: 'a_key' }

      response '201', 'creates a protocol subscription' do
        run_test! do
          protocol = Protocol.find_by name: protocol_name
          expect(protocol).to be_present
          expect(protocol.measurements.first.questionnaire.key).to eq questionnaire_key
          expect(protocol.push_subscriptions.first.name).to eq push_subscription_name
        end
      end

      response '400', 'bad request' do
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
end
