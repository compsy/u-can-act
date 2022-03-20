# frozen_string_literal: true

require 'swagger_helper'

describe 'Person API' do
  let!(:people) { FactoryBot.create_list(:auth_user, 10, :with_person) }

  path '/basic_auth_api/person' do
    post 'Create a person' do
      tags 'Person'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: {
          sub: { type: :string },
          metadata: {
            type: :object,
            properties: {
              team: { type: :string },
              role: { type: :string },
              email: { type: :string, format: :email }
            }
          }
        }
      }

      let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
      let!(:team) { FactoryBot.create :team, :with_roles }

      let!(:person) do
        {
          person: {
            sub: 'sub1',
            Rails.application.config.settings.metadata_field => {
              team: team.name,
              role: team.roles.first.title,
              email: 'email1@example.com'
            }
          }
        }
      end

      response '201', 'created' do
        run_test! do
          auth_user = AuthUser.find_by auth0_id_string: 'sub1'
          expect(auth_user).to be_present
          p = Person.find_by email: 'email1@example.com'
          expect(p).to be_present
        end
      end

      response '400', 'bad request' do
        let(:person) { { person: { sub: 'sub1' } } }
        run_test!
      end

      response '400', 'validates request body', document: false do
        let(:person) { {} }
        run_test!
      end

      response '400', 'validates person model', document: false do
        let!(:person) do
          {
            person: {
              sub: 'sub1',
              Rails.application.config.settings.metadata_field => {
                team: team.name,
                role: team.roles.first.title,
                email: 'invalid email'
              }
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

  path '/basic_auth_api/person/show_list' do
    get 'Shows a list of persons' do
      tags 'Person'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: {
          person_auth0_ids: { type: :array }
        }
      }

      let(:person) { { person_auth0_ids: [] } }

      response '200', 'lists all people' do
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
