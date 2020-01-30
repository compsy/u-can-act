# frozen_string_literal: true

class CalculateDistributionsJob < ApplicationJob
  queue_as :default

  def perform
    clean_up_redis
    Questionnaire.find_each do |questionnaire|
      RedisMutex.with_lock("Distribution:#{questionnaire.key}") do
        CalculateDistribution.run!(questionnaire: questionnaire)
      end
    end
  end

  def clean_up_redis
    RedisService.keys.each do |key|
      next unless key.match?(/^distribution_/)

      # Delete the distribution unless it is a known questionnaire. Here we strip the prefix 'distribution_'
      # from the redis key to get the key of the questionnaire.
      RedisService.del(key) unless Questionnaire.where(key: key[('distribution_'.length)..]).count.positive?
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
