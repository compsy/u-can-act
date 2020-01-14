# frozen_string_literal: true

# We prefer redis_url here. The reason is that Heroku's redis URL might change without notification. Hence copying the password and host
# is not really an option then.
RedisService = if ENV['REDIS_URL']
                 Redis.new(url: ENV['REDIS_URL'])
               else
                 Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'])
               end
RedisClassy.redis = if ENV['REDIS_URL']
                 Redis.new(url: ENV['REDIS_URL'])
               else
                 Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'])
               end
