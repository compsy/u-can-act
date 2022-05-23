# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a basic authenticated route' do |method, route|
  # Disabling rubocop, it currently only does this because of the params || {} line
  def call_url(method, route)
    case method
    when 'get'
      get route, params: (params || {}) if method == 'get'
    when 'post'
      post route, params: (params || {}) if method == 'post'
    end
  end

  it 'returns a 401 when not authenticated' do
    call_url(method, route)
    expect(response.status).to eq 401
    expect(response.body).to include 'HTTP Basic: Access denied.'
  end

  it 'returns a 401 when not authenticated due to wrong password' do
    basic_api_auth name: 'wrong', password: 'wronger'
    call_url(method, route)
    expect(response.status).to eq 401
    expect(response.body).to include 'HTTP Basic: Access denied.'
  end

  it 'heads 401 without an api secret' do
    pre_secret = ENV.fetch('API_SECRET', nil)
    ENV['API_SECRET'] = ''
    expect(ENV.fetch('API_SECRET', nil)).to be_blank
    basic_api_auth name: ENV.fetch('API_KEY', nil), password: ''

    call_url(method, route)
    expect(response.status).to eq 401
    expect(response.body).to include 'HTTP Basic: Access denied.'
    ENV['API_SECRET'] = pre_secret
  end

  it 'returns a 2xx if the route is authenticated' do
    basic_api_auth name: ENV.fetch('API_KEY', nil), password: ENV.fetch('API_SECRET', nil)
    call_url(method, route)
    expect(response.status).to be < 300
    expect(response.status).to be >= 200
  end
end
