# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::AuthUserController, type: :controller do
  let(:the_auth_user) { FactoryBot.create(:auth_user) }
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:team) { FactoryBot.create(:team, :with_roles) }

  describe 'unauthorized' do
    let!(:the_payload) do
      { ENV.fetch('SITE_LOCATION', nil) => {
        'access_level' => ['user'],
        'team' => team.name,
        'protocol' => protocol.name
      } }
    end
    it_behaves_like 'a jwt authenticated route', 'post', :create
  end

  describe 'authorized' do
    let(:auth0_id_string) { 'some-auth0-id' }
    describe 'create' do
      let!(:the_payload) do
        { ENV.fetch('SITE_LOCATION', nil) => {
          'access_level' => ['user'],
          'team' => team.name,
          'protocol' => protocol.name
        } }
      end

      before do
        the_payload[:sub] = auth0_id_string
        jwt_auth the_payload
      end

      it 'creates a new auth_user' do
        pre_count = AuthUser.count
        post :create
        post_count = AuthUser.count
        expect(post_count).to eq pre_count + 1
      end

      it 'creates a new person in the correct team' do
        pre_count = Person.count
        post :create
        post_count = Person.count
        expect(post_count).to eq pre_count + 1
        user = AuthUser.find_by(auth0_id_string: auth0_id_string)
        expect(user.person).to_not be_nil
        expect(user.person.role).to_not be_nil
        expect(user.person.role).to eq team.roles.first
      end

      it 'calls the correct serializer' do
        allow(controller).to receive(:render)
          .with(json: instance_of(AuthUser), serializer: Api::AuthUserSerializer)
          .and_call_original
        post :create
      end
    end
  end
end
