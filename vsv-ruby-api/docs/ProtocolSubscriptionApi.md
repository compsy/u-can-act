# VsvRubyApi::ProtocolSubscriptionApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**basic_auth_api_protocol_subscriptions_post**](ProtocolSubscriptionApi.md#basic_auth_api_protocol_subscriptions_post) | **POST** /basic_auth_api/protocol_subscriptions | Creates a new protocol subscription
[**protocol_subscriptions_delegated_protocol_subscriptions_get**](ProtocolSubscriptionApi.md#protocol_subscriptions_delegated_protocol_subscriptions_get) | **GET** /protocol_subscriptions/delegated_protocol_subscriptions | Lists all my students their protocolsubscriptions
[**protocol_subscriptions_mine_get**](ProtocolSubscriptionApi.md#protocol_subscriptions_mine_get) | **GET** /protocol_subscriptions/mine | Lists all my protocolsubscriptions


# **basic_auth_api_protocol_subscriptions_post**
> basic_auth_api_protocol_subscriptions_post(opts)

Creates a new protocol subscription

### Example
```ruby
# load the gem
require 'vsv-ruby-api'
# setup authorization
VsvRubyApi.configure do |config|
  # Configure API key authorization: BasicAuth
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = VsvRubyApi::ProtocolSubscriptionApi.new

opts = { 
  protocol_subscription: VsvRubyApi::ProtocolSubscription.new # ProtocolSubscription | 
}

begin
  #Creates a new protocol subscription
  api_instance.basic_auth_api_protocol_subscriptions_post(opts)
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolSubscriptionApi->basic_auth_api_protocol_subscriptions_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **protocol_subscription** | [**ProtocolSubscription**](ProtocolSubscription.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **protocol_subscriptions_delegated_protocol_subscriptions_get**
> Array&lt;InlineResponse2002&gt; protocol_subscriptions_delegated_protocol_subscriptions_get

Lists all my students their protocolsubscriptions

### Example
```ruby
# load the gem
require 'vsv-ruby-api'
# setup authorization
VsvRubyApi.configure do |config|
  # Configure API key authorization: JwtAuth
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = VsvRubyApi::ProtocolSubscriptionApi.new

begin
  #Lists all my students their protocolsubscriptions
  result = api_instance.protocol_subscriptions_delegated_protocol_subscriptions_get
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolSubscriptionApi->protocol_subscriptions_delegated_protocol_subscriptions_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;InlineResponse2002&gt;**](InlineResponse2002.md)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **protocol_subscriptions_mine_get**
> Array&lt;InlineResponse2002&gt; protocol_subscriptions_mine_get

Lists all my protocolsubscriptions

### Example
```ruby
# load the gem
require 'vsv-ruby-api'
# setup authorization
VsvRubyApi.configure do |config|
  # Configure API key authorization: JwtAuth
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = VsvRubyApi::ProtocolSubscriptionApi.new

begin
  #Lists all my protocolsubscriptions
  result = api_instance.protocol_subscriptions_mine_get
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolSubscriptionApi->protocol_subscriptions_mine_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;InlineResponse2002&gt;**](InlineResponse2002.md)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



