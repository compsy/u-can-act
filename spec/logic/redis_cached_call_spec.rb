# frozen_string_literal: true

require 'rails_helper'

describe RedisCachedCall do
  describe 'cache' do
    let(:key) { 'key' }
    let(:bust_cache) { false }
    it 'should call the redis service to reset the cache if bust cache is set' do
      expect(RedisService).to receive(:set).with(key, Marshal.dump('test')).and_raise('stop_execution')
      expect {described_class.cache(key, true) { 'test' }}.to raise_error('stop_execution')
    end

    it 'should call the redis service to retrieve the cache' do
      result = 'test123'
      final_result = 'somethingelse'
      expect(RedisService).to receive(:exists).with(key).and_return(true)
      expect(RedisService).to receive(:get).with(key).and_return(result)
      expect(Marshal).to receive(:load).with(result).and_return(final_result)
      described_class.cache(key, bust_cache) { 'test' }
    end

    it 'should call the block provided to the function and store its results in the cache' do
      marshalled_output = 'test123'
      expected = 'somethingelse'
      expect(RedisService).to receive(:exists).with(key).and_return(false)
      expect(RedisService).to_not receive(:get)
      expect(Marshal).to_not receive(:load)
      expect(Marshal).to receive(:dump).with(expected).and_return(marshalled_output)
      expect(RedisService).to receive(:set).with(key, marshalled_output)

      called = false
      result = described_class.cache(key, bust_cache) do
        called = true
        expected
      end
      expect(called).to be_truthy
      expect(result).to eq expected
    end

    it 'should not call the block provided to the function and store its results in the cache' do
      marshalled_output = 'test123'
      expected = 'test'
      expect(RedisService).to receive(:get).with(key).and_return(Marshal.dump(expected))
      expect(RedisService).to receive(:exists).with(key).and_return(true)
      expect(Marshal).to_not receive(:dump)
      expect(RedisService).to_not receive(:set)

      called = false
      result = described_class.cache(key, bust_cache) do
        called = true
        raise('should not happen!')
      end
      expect(called).to be_falsey
      expect(result).to eq expected
    end
  end
end
