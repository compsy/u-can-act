# frozen_string_literal: true

class CacheOverview
  def self.run
    RedisOverviewJob.perform_later
  end
end
