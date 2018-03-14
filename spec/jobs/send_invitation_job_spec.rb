# frozen_string_literal: true

require 'rails_helper'

describe SendInvitationJob, type: :job do
  let(:token) { 'abcd' }

  describe '#perform_later' do
    it 'performs something later' do
      invitation = FactoryBot.create(:sms_invitation)
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(invitation, token)
      end.to have_enqueued_job(described_class)
    end
  end

  describe '#perform' do
    let(:invitation) { FactoryBot.create(:sms_invitation, invited_state: Invitation::SENDING_STATE) }
    it 'should send the invitation' do
      expect(invitation).to receive(:send_invite).with(token)
      subject.perform(invitation, token)
    end
    it 'should update the invited_state' do
      expect(invitation).to receive(:send_invite).with(token)
      expect(invitation.invited_state).to eq Invitation::SENDING_STATE
      subject.perform(invitation, token)
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::SENT_STATE
    end
    it 'should update the invited_state for reminders' do
      invitation.invited_state = Invitation::SENDING_REMINDER_STATE
      invitation.save!
      expect(invitation).to receive(:send_invite).with(token)
      expect(invitation.invited_state).to eq Invitation::SENDING_REMINDER_STATE
      subject.perform(invitation, token)
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::REMINDER_SENT_STATE
    end
  end

  describe 'max_attempts' do
    it 'should be two' do
      expect(subject.max_attempts).to eq 2
    end
  end

  describe 'reschedule_at' do
    it 'should be in one hour' do
      time_now = Time.zone.now
      expect(subject.reschedule_at(time_now, 1)).to be_within(1.minute)
        .of(TimeTools.increase_by_duration(time_now, 1.hour))
    end
  end
end
