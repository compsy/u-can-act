# frozen_string_literal: true

require 'swagger_helper'

describe 'Person API' do
  let!(:people) { FactoryBot.create_list(:auth_user, 10, :with_person) }

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
  path '/basic_auth_api/person/{id}' do
    delete 'destroys a user' do
      tags 'Person'
      produces 'application/json'
      security [BasicAuth: {}]
      parameter name: :id, in: :path, schema: { type: :number }
      let(:person) { { person_auth0_ids: [] } }

      response '204', 'destroys a person' do
        let!(:id) { FactoryBot.create(:person).id }
        let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }
        run_test!
      end

      response '401', 'not authenticated' do
        let!(:id) { FactoryBot.create(:person).id }
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
