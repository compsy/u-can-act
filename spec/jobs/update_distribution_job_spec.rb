# frozen_string_literal: true

require 'rails_helper'

describe UpdateDistributionJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(1)
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'calls the update distribution use case with the correct parameters' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      response = FactoryBot.create(:response,
                                   protocol_subscription: protocol_subscription,
                                   completed_at: Time.zone.now,
                                   filled_out_by: protocol_subscription.person,
                                   filled_out_for: protocol_subscription.filling_out_for)
      expect(UpdateDistribution).to receive(:run!).with(questionnaire: response.measurement.questionnaire,
                                                        response: response)
      described_class.perform_now(response.id)
    end
  end

  describe 'max_attempts' do
    it 'is two' do
      expect(subject.max_attempts).to eq 2
    end
  end

  describe 'reschedule_at' do
    it 'is in one hour' do
      time_now = Time.zone.now
      expect(subject.reschedule_at(time_now, 1)).to be_within(1.minute)
        .of(TimeTools.increase_by_duration(time_now, 5.minutes))
    end
  end
end
