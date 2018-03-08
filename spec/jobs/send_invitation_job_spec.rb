# frozen_string_literal: true

require 'rails_helper'

describe SendInvitationJob, type: :job do
  let(:token) { 'abcd' }

  describe '#perform_later' do
    it 'performs something later' do
      invitation = FactoryBot.create(:sms_invitation)
      ActiveJob::Base.queue_adapter = :test
      expect do
        SendInvitationJob.perform_later(invitation, token)
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
end
