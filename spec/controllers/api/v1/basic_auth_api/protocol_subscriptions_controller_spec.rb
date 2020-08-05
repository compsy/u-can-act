# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BasicAuthApi::ProtocolSubscriptionsController, type: :controller do
  let!(:auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let!(:person) { auth_user.person }
  let!(:mentor) { FactoryBot.create(:mentor) }
  let!(:protocol) { FactoryBot.create(:protocol) }
  let!(:params) { { protocol_name: protocol.name, auth0_id_string: auth_user.auth0_id_string } }
  let!(:external_identifier) { 'external_identifier' }

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
        start_date: time,
        external_identifier: nil
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
        end_date: time,
        external_identifier: external_identifier
      ).and_return true

      post :create, params: { protocol_name: prot_name,
                              start_date: time,
                              end_date: time,
                              auth0_id_string: auth_user.auth0_id_string,
                              external_identifier: external_identifier }
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
        start_date: time,
        external_identifier: nil
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

  describe '#delegated_protocol_subscriptions' do
    before do
      basic_auth 'admin', 'admin'
    end

    it 'should not give an error' do
      get :delegated_protocol_subscriptions, params: { external_identifier: external_identifier }
      expect(response.status).to eq 200
      json_data = JSON.parse(response.body)
      expect(json_data).to eq([])
    end

    it 'should give an error status when called without external identifier' do
      get :delegated_protocol_subscriptions
      expect(response.status).to eq 422
    end

    it 'should return serialized protocol subscriptions with the given external identifier' do
      FactoryBot.create(:protocol_subscription)
      protocol_subscription = FactoryBot.create(:protocol_subscription, external_identifier: external_identifier)
      get :delegated_protocol_subscriptions, params: { external_identifier: external_identifier }
      expect(response.status).to eq 200
      json_data = JSON.parse(response.body)
      expect(json_data.length).to eq(1)
      expect(json_data[0]['person_type']).to eq(protocol_subscription.person.role.group)
      expect(json_data[0]['name']).to eq(protocol_subscription.protocol.name)
      expect(json_data[0]['first_name']).to eq(protocol_subscription.person.first_name)
      expect(json_data[0]['id']).to eq(protocol_subscription.id)
    end
  end

  describe '#destroy' do
    before do
      basic_auth 'admin', 'admin'
    end
    let!(:protocol_subscription) { FactoryBot.create(:protocol_subscription, external_identifier: external_identifier) }

    it 'cancels a protocol subscription' do
      expect(protocol_subscription.state).to eq ProtocolSubscription::ACTIVE_STATE
      expect do
        delete :destroy, params: { external_identifier: external_identifier,
                                   id: protocol_subscription.id }
      end.not_to change(ProtocolSubscription, :count)
      expect(response.status).to eq 200
      expect(response.body).to match(/destroyed/)
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::CANCELED_STATE
    end

    it 'should give an error status when called without external identifier' do
      get :delegated_protocol_subscriptions, params: { id: protocol_subscription.id }
      expect(response.status).to eq 422
    end

    it 'should give an error status when the protocol subscription could not be found' do
      protocol_subscription.update!(external_identifier: 'something_else')
      delete :destroy, params: { external_identifier: external_identifier,
                                 id: protocol_subscription.id }
      expect(response.status).to eq 404
      expect(response.body).to match(/Protocol subscription met dat ID niet gevonden/)
    end
  end
end
