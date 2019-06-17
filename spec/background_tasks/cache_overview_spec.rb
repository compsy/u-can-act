# frozen_string_literal: true

require 'rails_helper'

describe CacheOverview do
  describe 'run' do
    it 'calls redisoverviewjob with a perform_later' do
      expect(RedisOverviewJob).to receive(:perform_later)
      described_class.run
    end
  end
end
