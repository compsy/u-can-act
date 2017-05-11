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
    let(:response) { FactoryGirl.create(:response) }
    it 'should send the invitation' do
      expect(SendInvitation).to receive(:run!).with(response: response)
      subject.perform(response)
    end
    it 'should update the invited_state' do
      expect(SendInvitation).to receive(:run!).with(response: response)
      expect(response.invited_state).to eq Response::NOT_SENT_STATE
      subject.perform(response)
      response.reload
      expect(response.invited_state).to eq Response::SENT_STATE
    end
  end
end
