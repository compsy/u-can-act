# frozen_string_literal: true

require 'rails_helper'

describe TimeTools do
  describe 'increase_by_duration' do
    it 'should increase the duration by the given amount' do
      given = Time.new(2017, 5, 11, 12, 29, 0).in_time_zone
      expected = Time.new(2017, 5, 11, 13, 29, 0).in_time_zone
      expect(described_class.increase_by_duration(given, 1.hour)).to be_within(1.second).of(expected)
      expect(described_class.increase_by_duration(given, 3600)).to be_within(1.second).of(expected)
    end
    it 'should increase the duration by the given amount when changing from winter time to summer time' do
      # changes at 2AM Sunday, March 26 2017
      given = Time.new(2017, 3, 23, 19, 39, 23).in_time_zone
      expected = Time.new(2017, 3, 30, 19, 39, 23).in_time_zone
      expect(described_class.increase_by_duration(given, 1.week)).to be_within(1.second).of(expected)
      expect(described_class.increase_by_duration(given, 7.days)).to be_within(1.second).of(expected)
      expect(described_class.increase_by_duration(given, 3600 * 24 * 7)).to be_within(1.second).of(expected)
    end
    it 'should increase the duration by the given amount when changing from summer time to winter time' do
      # changes at 3AM Sunday, October 29 2017
      given = Time.new(2017, 10, 25, 6, 6, 7).in_time_zone
      expected = Time.new(2017, 11, 1, 6, 6, 7).in_time_zone
      expect(described_class.increase_by_duration(given, 1.week)).to be_within(1.second).of(expected)
      expect(described_class.increase_by_duration(given, 7.days)).to be_within(1.second).of(expected)
      expect(described_class.increase_by_duration(given, 3600 * 24 * 7)).to be_within(1.second).of(expected)
    end
  end
end
