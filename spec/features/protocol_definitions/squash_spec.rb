# frozen_string_literal: true

require 'rails_helper'

fdescribe 'squash protocol', type: :request do
  before(:each) do
      basic_auth 'admin', 'admin'
  end

  context 'squash protocol' do
    before do
      load Rails.root.join('projects/sport-data-valley/seeds/questionnaires/squash.rb')
      load Rails.root.join('projects/sport-data-valley/seeds/protocols/squash.rb')
    end
    let!(:member) { FactoryBot.create(:person, :with_auth_user)}
    let!(:mentor) { FactoryBot.create(:person, :with_auth_user)}
    let(:protocol) { Protocol.first }

    it 'should set the correct protocol' do
      expect(protocol.name).to eq 'squash'
    end
    let(:start) {Time.zone.now}
    let(:endd) {start + 1.day}
    let(:body) do
      {
        protocol_name: protocol.name,
        auth0_id_string: member.auth_user.auth0_id_string,
        start_date: start,
        end_date: endd,
        mentor_id: mentor.id
      }
    end

    it 'should start a protocol subscription right now' do
      pre_count = ProtocolSubscription.count
      expect(member.protocol_subscriptions.count).to eq 0
      http_auth_as 'admin', 'admin' do
        auth_post '/api/v1/basic_auth_api/protocol_subscriptions', body
        expect(response.status).to eq 201
      end
      post_count = ProtocolSubscription.count
      expect(post_count).to eq (pre_count + 1)
      expect(member.protocol_subscriptions.count).to eq 1
    end

    it 'should send an invite imediately' do
      pre_count = InvitationSet.count
      http_auth_as 'admin', 'admin' do
        auth_post '/api/v1/basic_auth_api/protocol_subscriptions', body
        expect(response.status).to eq 201
      end
      post_count = InvitationSet.count
      expect(post_count).to eq (pre_count + 1)
    end
  end
end
