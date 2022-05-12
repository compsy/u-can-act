# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Admin::AdminApiController, type: :controller do
  let!(:the_auth_user) { FactoryBot.create(:auth_user, :admin) }
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:team) { FactoryBot.create(:team, :with_roles) }
  let!(:the_payload) do
    { ENV.fetch('SITE_LOCATION', nil) => {
      'access_level' => ['user'],
      'team' => team.name,
      'protocol' => protocol.name
    } }
  end
  controller do
    def dummy
      render plain: 'dummy called'
    end
  end

  before do
    routes.draw { get 'dummy' => 'api/v1/admin/admin_api#dummy' }
  end

  it_behaves_like 'a jwt authenticated route', 'get', :dummy

  it 'raises 403 if we are not an admin user' do
    the_payload[:sub] = FactoryBot.create(:auth_user).auth0_id_string
    jwt_auth the_payload
    get :dummy
    expect(response.status).to eq 403
    expect(response.body).to_not be_nil

    expected = { result: 'User is not an admin' }.to_json
    expect(response.body).to eq expected
  end
end
