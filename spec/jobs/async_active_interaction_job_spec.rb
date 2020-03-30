# frozen_string_literal: true

require 'rails_helper'

describe AsyncActiveInteractionJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(1)
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'calls the sself argument with args and run with the correct parameters' do
      tim = Time.zone.now.change(usec: 0)
      expect(AsyncActiveInteraction).to receive(:run!).with(one: 2, three: 4, four: tim)
      args = Marshal.dump([{ one: 2, three: 4, four: tim }])
      described_class.perform_now('AsyncActiveInteraction', args)
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
