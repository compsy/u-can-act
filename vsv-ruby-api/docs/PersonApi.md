# VsvRubyApi::PersonApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**basic_auth_api_person_show_list_get**](PersonApi.md#basic_auth_api_person_show_list_get) | **GET** /basic_auth_api/person/show_list | Shows a list of persons
[**person_me_get**](PersonApi.md#person_me_get) | **GET** /person/me | Gets the current person
[**person_put**](PersonApi.md#person_put) | **PUT** /person | Updates the current user


# **basic_auth_api_person_show_list_get**
> basic_auth_api_person_show_list_get(opts)

Shows a list of persons

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

api_instance = VsvRubyApi::PersonApi.new

opts = { 
  person: VsvRubyApi::Person.new # Person | 
}

begin
  #Shows a list of persons
  api_instance.basic_auth_api_person_show_list_get(opts)
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling PersonApi->basic_auth_api_person_show_list_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **person** | [**Person**](Person.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **person_me_get**
> InlineResponse200 person_me_get

Gets the current person

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

api_instance = VsvRubyApi::PersonApi.new

begin
  #Gets the current person
  result = api_instance.person_me_get
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling PersonApi->person_me_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **person_put**
> InlineResponse200 person_put(opts)

Updates the current user

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

api_instance = VsvRubyApi::PersonApi.new

opts = { 
  person: VsvRubyApi::Person1.new # Person1 | 
}

begin
  #Updates the current user
  result = api_instance.person_put(opts)
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling PersonApi->person_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **person** | [**Person1**](Person1.md)|  | [optional] 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

[JwtAuth](../README.md#JwtAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



