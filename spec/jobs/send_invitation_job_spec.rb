# frozen_string_literal: true

require 'rails_helper'

describe SendInvitationJob, type: :job do
  describe '#perform_later' do
    it 'performs something later' do
      response = FactoryGirl.create(:response)
      ActiveJob::Base.queue_adapter = :test
      expect do
        SendInvitationJob.perform_later(response)
      end.to have_enqueued_job(SendInvitationJob)
    end
  end
  describe '#perform' do
    let(:response) { FactoryGirl.create(:response, invited_state: Response::SENDING_STATE) }
    it 'should send the invitation' do
      expect(SendInvitation).to receive(:run!).with(response: response)
      subject.perform(response)
    end
    it 'should update the invited_state' do
      expect(SendInvitation).to receive(:run!).with(response: response)
      expect(response.invited_state).to eq Response::SENDING_STATE
      subject.perform(response)
      response.reload
      expect(response.invited_state).to eq Response::SENT_STATE
    end
    it 'should update the invited_state for reminders' do
      response.invited_state = Response::SENDING_REMINDER_STATE
      response.save!
      expect(SendInvitation).to receive(:run!).with(response: response)
      expect(response.invited_state).to eq Response::SENDING_REMINDER_STATE
      subject.perform(response)
      response.reload
      expect(response.invited_state).to eq Response::REMINDER_SENT_STATE
    end
  end
end
