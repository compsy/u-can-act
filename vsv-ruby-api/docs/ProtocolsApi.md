# VsvRubyApi::ProtocolsApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**protocol_get**](ProtocolsApi.md#protocol_get) | **GET** /protocol | Lists all protocols


# **protocol_get**
> Array&lt;InlineResponse2001&gt; protocol_get(opts)

Lists all protocols

### Example
```ruby
# load the gem
require 'vsv-ruby-api'

api_instance = VsvRubyApi::ProtocolsApi.new

opts = { 
  authorization: "authorization_example" # String | 
}

begin
  #Lists all protocols
  result = api_instance.protocol_get(opts)
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolsApi->protocol_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String**|  | [optional] 

### Return type

[**Array&lt;InlineResponse2001&gt;**](InlineResponse2001.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



