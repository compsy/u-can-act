# frozen_string_literal: true

class RedisOverviewJob
  def self.run
    Team.overview(bust_cache: true)
  end
end
