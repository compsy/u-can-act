# frozen_string_literal: true

# We prefer redis_url here. The reason is that Heroku's redis URL might change without notification. Hence copying the password and host
# is not really an option then.
redis_url = ENV['REDISCLOUD_URL']
redis_url = ENV['REDIS_URL'] if redis_url.blank?
RedisService = if redis_url
                 Redis.new(url: redis_url)
               else
                 Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'])
               end
RedisClassy.redis = if redis_url
                 Redis.new(url: redis_url)
               else
                 Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'])
               end
