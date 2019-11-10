# VsvRubyApi::AuthUserApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auth_user_post**](AuthUserApi.md#auth_user_post) | **POST** /auth_user | Creates an auth user


# **auth_user_post**
> auth_user_post(opts)

Creates an auth user

### Example
```ruby
# load the gem
require 'vsv-ruby-api'

api_instance = VsvRubyApi::AuthUserApi.new

opts = { 
  authorization: "authorization_example" # String | 
}

begin
  #Creates an auth user
  api_instance.auth_user_post(opts)
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling AuthUserApi->auth_user_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String**|  | [optional] 

### Return type

nil (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



