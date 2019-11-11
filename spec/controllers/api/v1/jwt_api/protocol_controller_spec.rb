# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::ProtocolController, type: :controller do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }
  let!(:no_protocols) { 5 }
  let!(:protocols) { FactoryBot.create_list(:protocol, no_protocols) }

  let!(:the_payload) do
    { ENV['SITE_LOCATION'] => {} }
  end

  describe 'unauthorized' do
    it_behaves_like 'a jwt authenticated route', 'get', :index
  end

  describe 'authorized' do
    before do
      the_payload[:sub] = the_auth_user.auth0_id_string
      jwt_auth the_payload
    end

    describe 'index' do
      it 'returns 200' do
        get :index
        expect(response.status).to be 200
      end

      it 'renders all available protocols in the platform' do
        get :index
        result = JSON.parse(response.body)
        expect(result.length).to eq(no_protocols)
      end
    end
  end
end
