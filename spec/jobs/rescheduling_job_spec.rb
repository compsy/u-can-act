# frozen_string_literal: true

require 'rails_helper'

describe ReschedulingJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'calls the reschedule responses use case with the correct parameters' do
      FactoryBot.create(:protocol_subscription, :canceled)
      protsub = FactoryBot.create(:protocol_subscription)
      expect(RescheduleResponses).to receive(:run!).with(protocol_subscription: protsub,
                                                         future: kind_of(ActiveSupport::TimeWithZone))
      described_class.perform_now
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
