# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'an is_logged_in concern' do |route, params|
  render_views
  it 'requires a valid user' do
    get route, params: params
    expect(response).to have_http_status(:unauthorized)
    expect(response).to render_template(layout: 'application')
    expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
  end
end
