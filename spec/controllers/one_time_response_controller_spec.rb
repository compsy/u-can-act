# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimeResponseController, type: :controller do
  let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
  let(:one_time_response) { FactoryBot.create(:one_time_response, protocol: protocol) }
  let!(:team) { FactoryBot.create(:team, :with_roles, name: Rails.application.config.settings.default_team_name) }

  describe 'SHOW /' do
    it 'heads 404 if the provided token is not found' do
      get :show, params: { q: '123' }
      expect(response.status).to eq 404
    end

    it 'subscribes to a protocol when called with the correct token' do
      pre_count = ProtocolSubscription.count
      get :show, params: { q: one_time_response.token }
      post_count = ProtocolSubscription.count
      expect(pre_count + 1).to eq post_count
    end

    it 'does not subscribe to a protocol if the otr is restricted' do
      one_time_response.update!(restricted: true)
      pre_count = ProtocolSubscription.count
      get :show, params: { q: one_time_response.token }
      expect(response.status).to eq 404
      post_count = ProtocolSubscription.count
      expect(post_count).to eq pre_count
    end

    it 'creates the person when called' do
      pre_count = Person.count
      get :show, params: { q: one_time_response.token }
      post_count = Person.count
      expect(pre_count + 1).to eq post_count
    end

    it 'subscribes the person to the created protocol subscription' do
      expect(Person.count).to eq 0
      get :show, params: { q: one_time_response.token }
      expect(Person.count).to eq 1
      expect(Person.last.protocol_subscriptions.length).to eq 1
    end

    it 'redirects to token authentication controller' do
      get :show, params: { q: one_time_response.token }
      expect(response.status).to eq 302
      expect(response.location).to start_with 'http://test.host?q='
    end

    it 'schedules the correct responses' do
      protocol.measurements.first.update!(open_from_offset: 0)
      get :show, params: { q: one_time_response.token }
      expect(response.status).to eq 302
      expect(Person.last.my_open_responses.length).to eq 0
      expect(Person.last.all_my_open_responses.length).to eq 1
      expect(Person.last.my_open_one_time_responses.length).to eq 1
    end
  end
end
