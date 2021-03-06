=begin
#VSV V1

#No descripton provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)

OpenAPI spec version: v1

Generated by: https://github.com/swagger-api/swagger-codegen.git

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end

require "uri"

module VsvRubyApi
  class ProtocolSubscriptionApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Creates a new protocol subscription
    # 
    # @param [Hash] opts the optional parameters
    # @option opts [ProtocolSubscription] :protocol_subscription 
    # @return [nil]
    def basic_auth_api_protocol_subscriptions_post(opts = {})
      basic_auth_api_protocol_subscriptions_post_with_http_info(opts)
      return nil
    end

    # Creates a new protocol subscription
    # 
    # @param [Hash] opts the optional parameters
    # @option opts [ProtocolSubscription] :protocol_subscription 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def basic_auth_api_protocol_subscriptions_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: ProtocolSubscriptionApi.basic_auth_api_protocol_subscriptions_post ..."
      end
      # resource path
      local_var_path = "/basic_auth_api/protocol_subscriptions".sub('{format}','json')

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}

      # HTTP header 'Accept' (if needed)
      local_header_accept = []
      local_header_accept_result = @api_client.select_header_accept(local_header_accept) and header_params['Accept'] = local_header_accept_result

      # HTTP header 'Content-Type'
      local_header_content_type = ['application/json']
      header_params['Content-Type'] = @api_client.select_header_content_type(local_header_content_type)

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'protocol_subscription'])
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProtocolSubscriptionApi#basic_auth_api_protocol_subscriptions_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Lists all my students their protocolsubscriptions
    # 
    # @param [Hash] opts the optional parameters
    # @return [Array<InlineResponse2002>]
    def protocol_subscriptions_delegated_protocol_subscriptions_get(opts = {})
      data, _status_code, _headers = protocol_subscriptions_delegated_protocol_subscriptions_get_with_http_info(opts)
      return data
    end

    # Lists all my students their protocolsubscriptions
    # 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Array<InlineResponse2002>, Fixnum, Hash)>] Array<InlineResponse2002> data, response status code and response headers
    def protocol_subscriptions_delegated_protocol_subscriptions_get_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: ProtocolSubscriptionApi.protocol_subscriptions_delegated_protocol_subscriptions_get ..."
      end
      # resource path
      local_var_path = "/protocol_subscriptions/delegated_protocol_subscriptions".sub('{format}','json')

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}

      # HTTP header 'Accept' (if needed)
      local_header_accept = []
      local_header_accept_result = @api_client.select_header_accept(local_header_accept) and header_params['Accept'] = local_header_accept_result

      # HTTP header 'Content-Type'
      local_header_content_type = ['application/json']
      header_params['Content-Type'] = @api_client.select_header_content_type(local_header_content_type)

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['JwtAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Array<InlineResponse2002>')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProtocolSubscriptionApi#protocol_subscriptions_delegated_protocol_subscriptions_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Lists all my protocolsubscriptions
    # 
    # @param [Hash] opts the optional parameters
    # @return [Array<InlineResponse2002>]
    def protocol_subscriptions_mine_get(opts = {})
      data, _status_code, _headers = protocol_subscriptions_mine_get_with_http_info(opts)
      return data
    end

    # Lists all my protocolsubscriptions
    # 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Array<InlineResponse2002>, Fixnum, Hash)>] Array<InlineResponse2002> data, response status code and response headers
    def protocol_subscriptions_mine_get_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: ProtocolSubscriptionApi.protocol_subscriptions_mine_get ..."
      end
      # resource path
      local_var_path = "/protocol_subscriptions/mine".sub('{format}','json')

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}

      # HTTP header 'Accept' (if needed)
      local_header_accept = []
      local_header_accept_result = @api_client.select_header_accept(local_header_accept) and header_params['Accept'] = local_header_accept_result

      # HTTP header 'Content-Type'
      local_header_content_type = ['application/json']
      header_params['Content-Type'] = @api_client.select_header_content_type(local_header_content_type)

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['JwtAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Array<InlineResponse2002>')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProtocolSubscriptionApi#protocol_subscriptions_mine_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
