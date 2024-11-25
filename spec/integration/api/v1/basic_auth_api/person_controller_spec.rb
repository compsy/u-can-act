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

      let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
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

  path '/basic_auth_api/person/{id}' do
    delete 'Delete a person' do
      tags 'Person'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :id, in: :path, type: :string

      let!(:auth_user) { people.first }
      let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
      let!(:id) { auth_user.auth0_id_string }

      response '200', 'deleted' do
        run_test! do
          expect(Person.find_by(id: auth_user.person.id)).to be_nil
        end
      end

      response '404', 'not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end

    patch 'Update a person' do
      tags 'Person'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :id, in: :path, type: :string
      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: {
          metadata: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              mobile_phone: { type: :string, format: :mobile_phone },
              first_name: { type: :string, format: :first_name },
              last_name: { type: :string, format: :last_name }
            }
          }
        }
      }

      let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
      let!(:team) { FactoryBot.create :team, :with_roles }

      let!(:id) { people.first.auth0_id_string }
      let!(:person) do
        {
          person: {
            email: 'test@default.com',
            mobile_phone: '31612345678',
            first_name: 'Test',
            last_name: 'Default'
          }
        }
      end

      response '200', 'updated' do
        run_test! do
          p = Person.find_by email: 'test@default.com'
          expect(p).to be_present
          expect(p.mobile_phone).to eq '31612345678'
          expect(p.first_name).to eq 'Test'
          expect(p.last_name).to eq 'Default'
        end
      end

      response '404', 'not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '400', 'validates person model', document: false do
        let!(:person) do
          {
            person: {
              email: 'invalid email',
              mobile_phone: 'invalid phone',
              first_name: '',
              last_name: ''
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
        let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
