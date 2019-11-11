# VsvRubyApi::PersonApi

All URIs are relative to *https://localhost/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**person_me_get**](PersonApi.md#person_me_get) | **GET** /person/me | Gets the current person
[**person_put**](PersonApi.md#person_put) | **PUT** /person | Updates the current user


# **person_me_get**
> InlineResponse200 person_me_get(opts)

Gets the current person

### Example
```ruby
# load the gem
require 'vsv-ruby-api'

api_instance = VsvRubyApi::PersonApi.new

opts = { 
  authorization: "authorization_example" # String | 
}

begin
  #Gets the current person
  result = api_instance.person_me_get(opts)
  p result
rescue VsvRubyApi::ApiError => e
  puts "Exception when calling PersonApi->person_me_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String**|  | [optional] 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

No authorization required

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

api_instance = VsvRubyApi::PersonApi.new

opts = { 
  person: VsvRubyApi::Person.new, # Person | 
  authorization: "authorization_example" # String | 
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
 **person** | [**Person**](Person.md)|  | [optional] 
 **authorization** | **String**|  | [optional] 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



