# VsvRubyApi::ProtocolSubscriptionApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**protocol_subscriptions_mine_get**](ProtocolSubscriptionApi.md#protocol_subscriptions_mine_get) | **GET** /protocol_subscriptions/mine | Lists all my protocolsubscriptions


# **protocol_subscriptions_mine_get**
> Array&lt;InlineResponse2002&gt; protocol_subscriptions_mine_get(opts)

Lists all my protocolsubscriptions

### Example
```ruby
# load the gem
require 'vsv-ruby-api'

api_instance = VsvRubyApi::ProtocolSubscriptionApi.new

opts = { 
  authorization: "authorization_example" # String | 
}

begin
  #Lists all my protocolsubscriptions
  result = api_instance.protocol_subscriptions_mine_get(opts)
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolSubscriptionApi->protocol_subscriptions_mine_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String**|  | [optional] 

### Return type

[**Array&lt;InlineResponse2002&gt;**](InlineResponse2002.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



