# frozen_string_literal: true

require 'rails_helper'

describe 'GET /admin', type: :feature, js: true, focus: true do
  it 'should give a 404 error when not authorized' do
    visit '/admin'
    expect(page).to have_http_status(401)
  end

  it 'should be able to download questionnaires correctly' do
    basic_auth 'admin', 'admin'
    visit '/admin'
    expect(page).to have_http_status(200)
  end
end
