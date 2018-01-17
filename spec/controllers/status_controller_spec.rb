# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  describe 'GET /status' do
    it 'should have status code 200' do
      get :show
      expect(response).to have_http_status(200)
    end
    it 'should return OK' do
      get :show
      expect(response.body).to eq('OK')
    end
  end
end
