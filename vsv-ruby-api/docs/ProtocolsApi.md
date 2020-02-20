# VsvRubyApi::ProtocolsApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**protocol_get**](ProtocolsApi.md#protocol_get) | **GET** /protocol | Lists all protocols


# **protocol_get**
> Array&lt;InlineResponse2001&gt; protocol_get

Lists all protocols

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

api_instance = VsvRubyApi::ProtocolsApi.new

begin
  #Lists all protocols
  result = api_instance.protocol_get
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling ProtocolsApi->protocol_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;InlineResponse2001&gt;**](InlineResponse2001.md)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



