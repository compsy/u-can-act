# frozen_string_literal: true

class RedisCachedCall
  def self.cache(key, bust_cache, &block)
    if !bust_cache && RedisService.exists?(key)
      # Try to return the key from the cache
      result = RedisService.get(key)

      # Rubocop marks marshallload as unsafe as it can lead to remote code
      # execution # when loading from an untrusted source. In our case this is
      # not the case, so we can # ignore it here. See
      # http://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/MarshalLoad.
      # # Note that we are not using from / to json here, as these methods
      # won't properly encode the # symbols used. If we store symbols and
      # retrieve / parse the json later # (with symbolize_keys), the nested
      # keys are not converted correctly.  There are other ways but Marshal
      # is probably still the best option.
      # rubocop:disable Security/MarshalLoad
      return Marshal.load(result)
      # rubocop:enable Security/MarshalLoad
    end

    # Perform the actual call and store the results in the cache
    result = block.call
    RedisService.set(key, Marshal.dump(result))
    result
  end
end
