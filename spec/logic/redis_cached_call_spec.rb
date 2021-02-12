# frozen_string_literal: true

require 'rails_helper'

describe RedisCachedCall do
  describe 'cache' do
    let(:key) { 'key' }
    let(:bust_cache) { false }

    it 'calls the redis service to reset the cache if bust cache is set' do
      expect(RedisService).to receive(:set).with(key, Marshal.dump('test')).and_raise('stop_execution')
      expect { described_class.cache(key, true) { 'test' } }.to raise_error('stop_execution')
    end

    it 'calls the redis service to retrieve the cache' do
      result = 'test123'
      final_result = 'somethingelse'
      expect(RedisService).to receive(:exists?).with(key).and_return(true)
      expect(RedisService).to receive(:get).with(key).and_return(result)
      expect(Marshal).to receive(:load).with(result).and_return(final_result)
      described_class.cache(key, bust_cache) { 'test' }
    end

    it 'calls the block provided to the function and store its results in the cache' do
      marshalled_output = 'test123'
      expected = 'somethingelse'
      expect(RedisService).to receive(:exists?).with(key).and_return(false)
      expect(RedisService).not_to receive(:get)
      expect(Marshal).not_to receive(:load)
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

    it 'does not call the block provided to the function and store its results in the cache' do
      expected = 'test'
      expect(RedisService).to receive(:get).with(key).and_return(Marshal.dump(expected))
      expect(RedisService).to receive(:exists?).with(key).and_return(true)
      expect(Marshal).not_to receive(:dump)
      expect(RedisService).not_to receive(:set)

      result = described_class.cache(key, bust_cache) { raise('should not happen!') }
      expect(result).to eq expected
    end
  end
end
