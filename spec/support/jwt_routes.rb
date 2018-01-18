# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a jwt authenticated route' do |route, params|
  it 'should return a 401 when not authenticated' do
    get route, params: params
    expect(response.status).to eq 401
    expect(response.body).to include 'Unauthorized request'
  end

  it 'should return a 200 if the route is authenticated' do
    admin = FactoryGirl.create(:admin)
    payload = { sub: admin.auth0_id_string }
    jwt_auth payload
    get route, params: params
    expect(response.status).to eq 200
  end
end
