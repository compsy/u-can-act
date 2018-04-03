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
end
