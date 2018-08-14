# frozen_string_literal: true

require 'rails_helper'

describe 'sending invitations', type: :feature do
  let!(:some_response) do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
  end
  let!(:another_response) do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
    FactoryBot.create(:response, open_from: 90.minutes.ago, protocol_subscription: protocol_subscription)
  end
  let!(:third_response) do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    FactoryBot.create(:response, open_from: 45.minutes.ago, protocol_subscription: protocol_subscription)
  end
  let!(:fourth_response) do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
    FactoryBot.create(:response, :invited,
                      open_from: 30.minutes.ago,
                      protocol_subscription: protocol_subscription,
                      measurement: measurement)
  end
  let!(:fifth_response) do
    protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
    FactoryBot.create(:response,
                      open_from: (Response::RECENT_PAST + 1.hour).ago,
                      protocol_subscription: protocol_subscription,
                      measurement: measurement)
  end

  let!(:responses) { [some_response, another_response, third_response] }

  describe 'without delayed_jobs' do
    it 'should send sms messages for open responses' do
      mock_svc_messages

      MessageBirdAdapter.deliveries.clear
      Delayed::Worker.delay_jobs = false
      cntinvs = Invitation.count
      SendInvitations.run
      expect(Invitation.count).to eq(cntinvs + responses.length)
      expect(Delayed::Job.all.length).to eq(0)
      expect(MessageBirdAdapter.deliveries.size).to eq(2 * responses.length) # reminder and original

      MessageBirdAdapter.deliveries.each_with_index do |msg, index|
        responseobj = responses.select do |resp|
          resp.protocol_subscription.person_id == InvitationSet.all[1 + (index / 2)].person_id
        end.first
        responseobj.reload
        expect(msg[:to]).to eq(responseobj.protocol_subscription.person.mobile_phone)
        expect(msg[:body]).to_not be_blank
        expect(msg[:body]).to include('http')
        expect(msg[:body]).to include("?q=#{responseobj.protocol_subscription.person.external_identifier}" \
                                      "#{responseobj.invitation_set.invitation_tokens.first.token_plain}")
        expect(msg[:reference]).to eq "vsv-#{responseobj.invitation_set.id}"
      end

      Delayed::Worker.delay_jobs = true
    end

    describe 'without active protocol_subscriptions' do
      it 'should not do anything when the protocol_subscriptions are not active' do
        MessageBirdAdapter.deliveries.clear
        Delayed::Worker.delay_jobs = false

        responses.each do |resp|
          resp.protocol_subscription.update_attributes!(state: ProtocolSubscription::CANCELED_STATE)
        end
        MessageBirdAdapter.deliveries.clear
        SendInvitations.run
        expect(MessageBirdAdapter.deliveries).to be_empty

        Delayed::Worker.delay_jobs = true
      end
    end
  end

  describe 'with delayed jobs' do
    before :each do
      expect(Delayed::Worker.delay_jobs).to be_truthy
    end

    it 'should not schedule the sms if the delayed jobs are enabled' do
      MessageBirdAdapter.deliveries.clear
      expect(Delayed::Worker.delay_jobs).to be_truthy
      cntinvs = Invitation.count
      SendInvitations.run
      expect(Invitation.count).to eq(cntinvs + responses.length)
      expect(MessageBirdAdapter.deliveries.size).to eq 0
      expect(Delayed::Job.all.length).to eq(2 * responses.length)
    end
  end
end
