# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BasicAuthApi::ProtocolSubscriptionsController, type: :controller do
  let!(:auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let!(:person) { auth_user.person }
  let!(:mentor) { FactoryBot.create(:mentor) }
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
        mentor: mentor,
        end_date: nil,
        start_date: time
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              start_date: time,
                              mentor_id: mentor.id,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 201
    end

    it 'should also be able to run without a mentor' do
      expect(SubscribeToProtocol).to receive(:run!).with(
        protocol_name: prot_name,
        person: person,
        mentor: nil,
        start_date: time,
        end_date: time
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              start_date: time,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 201
    end

    it 'should start the protocol subscription on the correct start time, from a string' do
      post :create, params: { protocol_name: prot_name,
                              start_date: time.to_s,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 201
      expect(ProtocolSubscription.last.start_date).to eq time
    end

    it 'should be possible to call the url without a time' do
      Timecop.freeze(time)
      expect(SubscribeToProtocol).to receive(:run!).with(
        protocol_name: prot_name,
        person: person,
        mentor: mentor,
        end_date: nil,
        start_date: time
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              mentor_id: mentor.id,
                              auth0_id_string: auth_user.auth0_id_string }
      expect(response.status).to eq 201
      Timecop.return
    end

    it 'should head 404 if the user is not found' do
      post :create, params: { protocol_name: prot_name,
                              auth0_id_string: 'wrong id' }
      expect(response.status).to eq 404
    end
  end
end
