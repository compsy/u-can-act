# frozen_string_literal: true

require 'rails_helper'

describe SendInvitations do
  describe 'run' do
    it 'should call the recently_opened_and_not_sent scope' do
      expect(Response).to receive(:recently_opened_and_not_invited).and_return []
      described_class.run
    end

    describe 'loops through responses' do
      it 'should queue recent responses' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationsJob).to receive(:perform_later).and_return true
        expect(response.invitation_set_id).to be_nil
        invitationscount = Invitation.count
        invitationsetscount = InvitationSet.count
        described_class.run
        response.reload
        expect(Invitation.count).to eq(invitationscount + 2) # email and sms
        expect(InvitationSet.count). to eq(invitationsetscount + 1)
        expect(response.invitation_set_id).to_not be_nil
        expect(response.invitation_set_id).to eq InvitationSet.first.id
      end

      it 'should not queue a response that is expired' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryBot.create(:response, open_from: 3.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end

      it 'should not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  state: ProtocolSubscription::CANCELED_STATE,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end

      it 'should call the SendSms use case only once for multiple mentor responses' do
        mentor = FactoryBot.create(:mentor)

        responses = Array.new(10) do |_i|
          student = FactoryBot.create(:student)
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    start_date: 1.week.ago.at_beginning_of_day,
                                                    person: mentor, filling_out_for: student)
          response = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
          response
        end
        expect(SendInvitationJob).to receive(:perform_later).once.and_return true
        described_class.run
        responses.map!(&:reload)
        expect(responses.map(&:invited_state).uniq).to eq([Response::SENT_STATE, Response::SENDING_STATE])
        expect(responses.map(&:invited_state).select { |x| x == Response::SENDING_STATE }.count).to eq 1
      end
    end

    describe 'reminders' do
      it 'should queue recent responses' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryBot.create(:response, open_from: 9.hours.ago,
                                                protocol_subscription: protocol_subscription,
                                                invited_state: Response::SENT_STATE,
                                                measurement: measurement)
        expect(SendInvitationJob).to receive(:perform_later).with(response).and_return true
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENDING_REMINDER_STATE)
      end

      it 'should queue reminders for mentor responses' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, :mentor,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        expect(protocol_subscription.person_id).not_to eq(protocol_subscription.filling_out_for_id)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryBot.create(:response, open_from: 9.hours.ago,
                                                protocol_subscription: protocol_subscription,
                                                invited_state: Response::SENT_STATE,
                                                measurement: measurement)
        expect(SendInvitationJob).to receive(:perform_later).with(response).and_return true
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENDING_REMINDER_STATE)
      end

      it 'should not queue a response that is expired' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryBot.create(:response, open_from: 9.hours.ago,
                                                protocol_subscription: protocol_subscription,
                                                invited_state: Response::SENT_STATE)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end

      it 'should not queue a response outside the 2 hour reminder window' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryBot.create(:response, open_from: 11.hours.ago,
                                                protocol_subscription: protocol_subscription,
                                                invited_state: Response::SENT_STATE,
                                                measurement: measurement)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end

      it 'should not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  state: ProtocolSubscription::CANCELED_STATE)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryBot.create(:response, open_from: 9.hours.ago,
                                                protocol_subscription: protocol_subscription,
                                                invited_state: Response::SENT_STATE,
                                                measurement: measurement)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end
    end
  end
end
