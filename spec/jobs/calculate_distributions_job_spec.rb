# frozen_string_literal: true

require 'rails_helper'

describe CalculateDistributionsJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'calls the calculate distribution use case with the correct parameters' do
      expect(RedisService).to receive(:keys).and_return([])
      questionnaire = FactoryBot.create(:questionnaire)
      expect(CalculateDistribution).to receive(:run!).with(questionnaire: questionnaire)
      described_class.perform_now
    end
    it 'tries to delete redis cache for unknown questionnaires' do
      expect(RedisService).to receive(:keys).and_return(['distribution_unknown_key'])
      expect(RedisService).to receive(:del).with('distribution_unknown_key')
      questionnaire = FactoryBot.create(:questionnaire)
      expect(CalculateDistribution).to receive(:run!).with(questionnaire: questionnaire)
      described_class.perform_now
    end
    it 'doesn\'t delete redis cache for known questionnaires' do
      expect(RedisService).to receive(:keys).and_return(['distribution_known_key'])
      expect(RedisService).not_to receive(:del)
      questionnaire = FactoryBot.create(:questionnaire, key: 'known_key')
      expect(CalculateDistribution).to receive(:run!).with(questionnaire: questionnaire)
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
