# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'an is_logged_in_as_mentor concern' do |method, route|
  def call_url(method, route)
    params ||= {}
    case method
    when 'get'
      get route, params: params if method == 'get'
    when 'post'
      post route, params: params if method == 'post'
    end
  end

  it 'should head a 403 if the current person is not a mentor' do
    student = FactoryBot.create(:student)
    cookie_auth(student)
    call_url(method, route)
    expect(response.status).to eq 401
  end
end
