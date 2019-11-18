# VsvRubyApi::AuthUserApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auth_user_post**](AuthUserApi.md#auth_user_post) | **POST** /auth_user | Creates an auth user


# **auth_user_post**
> auth_user_post

Creates an auth user

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

api_instance = VsvRubyApi::AuthUserApi.new

begin
  #Creates an auth user
  api_instance.auth_user_post
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling AuthUserApi->auth_user_post: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

nil (empty response body)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



