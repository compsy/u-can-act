# frozen_string_literal: true

require 'rails_helper'

describe 'Admin authentication', type: :request do
  paths = { '/admin' => :get, '/questionnaire/interactive' => :get, '/questionnaire/interactive_render' => :post }

  def stub_admin_env(name, password)
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('ADMIN_USERNAME', nil).and_return(name)
    allow(ENV).to receive(:fetch).with('ADMIN_PASSWORD', nil).and_return(password)
  end

  paths.each do |path, verb|
    describe "#{verb.upcase} #{path}" do
      it 'is forbidden when the admin credentials are blank' do
        stub_admin_env('', '')
        send(verb, path, env: { 'HTTP_AUTHORIZATION' => 'Basic Og==' })
        expect(response).to have_http_status(:forbidden)
      end

      it 'is forbidden when the admin credentials are not set' do
        stub_admin_env(nil, nil)
        send(verb, path, env: { 'HTTP_AUTHORIZATION' => basic_encode('admin', 'admin') })
        expect(response).to have_http_status(:forbidden)
      end

      it 'is forbidden when only the admin password is blank' do
        stub_admin_env('admin', '')
        send(verb, path, env: { 'HTTP_AUTHORIZATION' => basic_encode('admin', '') })
        expect(response).to have_http_status(:forbidden)
      end

      it 'is unauthorized with wrong credentials' do
        stub_admin_env('admin', 'secret')
        send(verb, path, env: { 'HTTP_AUTHORIZATION' => basic_encode('admin', 'admin') })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  it 'allows an admin with the configured credentials' do
    stub_admin_env('admin', 'secret')
    get '/admin', env: { 'HTTP_AUTHORIZATION' => basic_encode('admin', 'secret') }
    expect(response).to have_http_status(:ok)
  end
end
