# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApiToken::ProtocolSubscriptionsController, type: :controller do
  let!(:auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let!(:person) { auth_user.person }
  let!(:protocol) { FactoryBot.create(:protocol) }
  let!(:params) { { protocol_name: protocol.name, auth0_id_string: auth_user.auth0_id_string } }

  it_behaves_like 'a basic authenticated route', 'post', :create

  describe '#CREATE' do
    before do
      basic_auth 'admin', 'admin'
    end

    let(:time) { Time.zone.now.change(usec: 0) }
    let(:prot_name) { protocol.name }
    it 'should call the SubscribeToProtocol with the correct params' do
      expect(SubscribeToProtocol).to receive(:run!).with(
        protocol_name: prot_name,
        person: person,
        start_date: time
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              start_date: time,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 200
    end

    it 'should be possible to call the url without a time' do
      Timecop.freeze(time)
      expect(SubscribeToProtocol).to receive(:run!).with(
        protocol_name: prot_name,
        person: person,
        start_date: time
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 200
      Timecop.return
    end

    it 'should head 404 if the user is not found' do
      post :create, params: { protocol_name: prot_name,
                              auth0_id_string: 'wrong id' }
      expect(response.status).to eq 404
    end
  end
end
