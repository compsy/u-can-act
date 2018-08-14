# frozen_string_literal: true

module Compsy
  module MicroserviceApi
    module Sessions
      class BasicAuthSession
        attr_reader :microservice_host
        attr_reader :username
        attr_reader :password

        def initialize(microservice_host: ENV['MICROSERVICE_HOST'],
                       username: ENV['MICROSERVICE_BASICAUTH_ID'],
                       password: ENV['MICROSERVICE_BASICAUTH_SECRET'])
          raise 'Mircoservice host not set' unless microservice_host.present?
          raise 'Mircoservice host should start with http[s]' unless microservice_host =~ %r{^http[s]?://.*}
          @microservice_host = microservice_host

          raise 'Mircoservice username not set' unless username.present?
          @username = username

          raise 'Mircoservice password not set' unless password.present?
          @password = password
        end

        def get(path, params = {})
          perform_request_or_fail do
            HTTParty.get(full_url_for(path),
                         query: merge_default_params(params),
                         basic_auth: basic_auth)
          end
        end

        def post(path, params = {})
          perform_request_or_fail do
            HTTParty.post(full_url_for(path),
                          headers: { 'Content-Type' => 'application/json' },
                          body: params.to_json,
                          query: default_params,
                          basic_auth: basic_auth)
          end
        end

        def patch(path, params = {})
          perform_request_or_fail do
            HTTParty.patch(full_url_for(path),
                           headers: { 'Content-Type' => 'application/json' },
                           body: merge_default_params(params).to_json,
                           basic_auth: basic_auth)
          end
        end

        def delete(path, params = {})
          perform_request_or_fail do
            HTTParty.delete(full_url_for(path),
                            query: merge_default_params(params),
                            basic_auth: basic_auth)
          end
        end

        private

        def merge_default_params(params)
          default_params.deep_merge(params)
        end

        def perform_request_or_fail
          response = yield
          case response.code
          when 200..299, 422
            response
          when 401
            access_denied(response)
          else
            raise response.parsed_response || "Received HTTP response code #{response.code}!"
          end
        end

        def access_denied(response)
          raise NoSession if response.headers['WWW-Authenticate']
          raise Unauthorized
        end

        def full_url_for(path)
          raise 'Path is mandatory' unless path.present?
          res = microservice_host + api_base + path
          puts res
          res
        end

        def api_base
          '/api/v1'
        end

        def default_params
          {
            blocking: true
          }
        end

        def basic_auth
          { username: username, password: password }
        end
      end
    end
  end
end
