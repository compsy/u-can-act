# frozen_string_literal: true

require 'rails_helper'

describe 'complete protocol subscriptions and cleanup invitation tokens', type: :feature do
  it 'should work without mocking the method' do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
    response = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription)
    FactoryBot.create(:invitation_token, invitation_set: response.invitation_set)
    expect(protocol_subscription.ended?).to be_truthy
    responsecountprev = Response.count
    invtokencountprev = InvitationToken.count
    expect(response.invitation_token).to_not be_nil
    expect(protocol_subscription.state).to eq(ProtocolSubscription::ACTIVE_STATE)
    CompleteProtocolSubscriptions.run
    CleanupInvitationTokens.run
    expect(Response.count).to eq responsecountprev
    expect(InvitationToken.count).to eq(invtokencountprev - 1)
    protocol_subscription.reload
    response.reload
    expect(protocol_subscription.state).to eq(ProtocolSubscription::COMPLETED_STATE)
    expect(response.invitation_token).to be_nil
  end
end
