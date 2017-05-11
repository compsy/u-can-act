# frozen_string_literal: true

require 'rails_helper'

describe CompleteProtocolSubscriptions do
  describe 'run' do
    it 'should call the active scope' do
      expect(ProtocolSubscription).to receive(:active).and_return []
      described_class.run
    end

    describe 'loops through active protocol subscriptions' do
      it 'should update their state to completed' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
        expect(protocol_subscription.ended?).to be_truthy
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::COMPLETED_STATE)
      end

      it 'should not affect canceled protocol subscriptions' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day,
                                                                           state: ProtocolSubscription::CANCELED_STATE)
        expect(protocol_subscription.ended?).to be_truthy
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::CANCELED_STATE)
      end

      it 'should not affect protocol subscriptions that have not yet ended' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
        expect(protocol_subscription.ended?).to be_falsey
        described_class.run
        protocol_subscription.reload
        expect(protocol_subscription.state).to eq(ProtocolSubscription::ACTIVE_STATE)
      end
    end
  end
end
