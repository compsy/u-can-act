# frozen_string_literal: true

class RedisCachedCall
  def self.cache(key, bust_cache, &block)
    if bust_cache
      RedisService.set(key, nil)
    else
      # Try to return the key from the cache
      result = RedisService.get(key)
      return Marshal.load(result) if result.present?
    end

    # Perform the actual call and store the results in the cache
    result = block.call
    RedisService.set(key, Marshal.dump(result))
    result
  end
end
