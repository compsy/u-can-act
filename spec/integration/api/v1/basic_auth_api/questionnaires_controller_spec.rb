# frozen_string_literal: true

require 'swagger_helper'

describe 'Questionnaires API' do
  path '/basic_auth_api/questionnaires/{id}' do
    get 'Shows a questionnaire' do
      tags 'Questionnaire'
      produces 'application/json'
      security [BasicAuth: {}]

      parameter name: :id, in: :path, type: :string, description: 'Questionnaire key'

      let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
      let!(:questionnaire) { FactoryBot.create :questionnaire }
      let(:id) { questionnaire.key }

      response '200', 'A questionnaire' do
        run_test!
      end

      response '404', 'Not found' do
        let(:id) { 'non-existent-key' }
        run_test!
      end

      response '401', 'Not authenticated.' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end

  path '/basic_auth_api/questionnaires' do
    post 'Creates a new questionnaire' do
      tags 'Questionnaire'
      consumes 'application/json'
      security [BasicAuth: {}]

      parameter name: :questionnaire, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          content: { type: :object },
          key: { type: :string },
          title: { type: :string }
        },
        required: %w[name content key]
      }, required: true

      let(:questionnaire) { FactoryBot.build(:questionnaire).attributes }

      response '201', 'A questionnaire was created.' do
        let!(:Authorization) { basic_encode(ENV.fetch('API_KEY', nil), ENV.fetch('API_SECRET', nil)) }
        run_test!
      end

      response '401', 'Not authenticated.' do
        let(:Authorization) { 'Bearer nil' }
        run_test!
      end
    end
  end
end
