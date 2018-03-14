
# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'an is_logged_in concern' do |route, params|
  it 'should require a valid user' do
    get route, params: params
    expect(response).to have_http_status(401)
    expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
  end
end
