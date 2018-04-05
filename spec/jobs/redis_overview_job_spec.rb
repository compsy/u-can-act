# frozen_string_literal: true

require 'rails_helper'

describe RedisOverviewJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'should call the Teamoverview function with the correct parameters' do
      expect(Team).to receive(:overview).with(bust_cache: true)
      described_class.perform_now
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
        .of(TimeTools.increase_by_duration(time_now, 5.minutes))
    end
  end
end
