# frozen_string_literal: true

require 'swagger_helper'

module Api
  module V1
    module BasicAuthApi
      describe 'Scheduling API', type: :request do
        let(:auth_string) { 'admin:admin' }
        let!(:Authorization) { basic_encode(ENV['API_KEY'], ENV['API_SECRET']) }

        path '/basic_auth_api/scheduling/daily_at_one_am' do
          post 'Runs the daily at 3 am jobs' do
            security [BasicAuth: {}]
            tags 'Scheduling'
            consumes 'application/json'
            response '201', 'Created' do
              run_test!
            end
          end
        end
        path '/basic_auth_api/scheduling/daily_at_two_am' do
          post 'Runs the daily at 3 am jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '201', 'Created' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/daily_at_three_am' do
          post 'Runs the daily at 3 am jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '201', 'Created' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/daily_at_four_am' do
          post 'Runs the daily at 4 am jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '204', 'No content' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/daily' do
          post 'Runs the daily jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '204', 'No content' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/hourly' do
          post 'Runs the hourly jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '204', 'No content' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/thirty_minutely' do
          post 'Runs the 30 minutely jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '204', 'No content' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/five_minutely' do
          post 'Runs the 5 minutely jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '201', 'Created' do
              run_test!
            end
          end
        end

        path '/basic_auth_api/scheduling/minutely' do
          post 'Runs the minutely jobs' do
            tags 'Scheduling'
            security [BasicAuth: {}]
            consumes 'application/json'
            response '204', 'No content' do
              run_test!
            end
          end
        end
      end
    end
  end
end
