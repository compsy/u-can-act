# frozen_string_literal: true

require 'rails_helper'

describe SendInvitations do
  describe 'run' do
    it 'should call the check_for_send scope' do
      expect(Response).to receive(:check_for_send).and_return []
      described_class.run
    end

    describe 'loops through responses' do
      it 'should queue recent responses' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).to receive(:perform_later).with(response).and_return true
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENDING_STATE)
      end

      it 'should not queue a response that is expired' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 3.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end

      it 'should not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   state: ProtocolSubscription::CANCELED_STATE,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end
    end
  end
end
