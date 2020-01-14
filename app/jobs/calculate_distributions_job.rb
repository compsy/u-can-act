# frozen_string_literal: true

class CalculateDistributionsJob < ApplicationJob
  queue_as :default

  def perform
    clean_up_redis
    Questionnaire.find_each do |questionnaire|
      CalculateDistribution.run!(questionnaire: questionnaire)
    end
  end

  def clean_up_redis
    RedisService.keys.each do |key|
      next unless key.match?(/^distribution_/)

      RedisService.del(key) unless Questionnaire.where(key: key[13..]).count.positive?
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
