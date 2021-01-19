# frozen_string_literal: true

require 'rails_helper'

describe CompleteProtocolSubscriptions do
  describe 'run' do
    it 'calls the active scope' do
      described_class.run
    end

    describe 'loops through active protocol subscriptions' do
      it 'updates their state to completed' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
        expect(protocol_subscription).to be_ended
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::COMPLETED_STATE)
      end

      it 'does not affect canceled protocol subscriptions' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day,
                                                                          state: ProtocolSubscription::CANCELED_STATE)
        expect(protocol_subscription).to be_ended
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::CANCELED_STATE)
      end

      it 'does not affect protocol subscriptions that have not yet ended' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
        expect(protocol_subscription).not_to be_ended
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::ACTIVE_STATE)
      end
    end
  end
end
