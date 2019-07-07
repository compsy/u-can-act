# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a jwt authenticated route' do |method, route|
  def call_url(method, route)
    params = nil
    params = the_params if defined? the_params

    return get route, params: params if method == 'get'
    post route, params: params if method == 'post'
  end

  it 'returns a 401 when not authenticated' do
    call_url(method, route)
    expect(response.status).to eq 401
    expect(response.body).to include 'Unauthorized request'
  end

  it 'returns a 2xx if the route is authenticated' do
    auth_user = nil
    payload = {}

    auth_user = the_auth_user if defined? the_auth_user
    payload = the_payload if defined? the_payload

    auth_user ||= FactoryBot.create(:auth_user)
    payload[:sub] = auth_user.auth0_id_string
    jwt_auth payload
    call_url(method, route)
    puts response.body if response.status >= 300 || response.status < 200
    expect(response.status).to be < 300
    expect(response.status).to be >= 200
  end
end
