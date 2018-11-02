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

  describe 'a_time?' do
    it 'should see an activesupport time with zone as a time' do
      time = Time.zone.now
      expect(described_class.a_time?(time)).to be_truthy
    end
    it 'should see a time as a time' do
      time = Time.new(2002)
      expect(described_class.a_time?(time)).to be_truthy
    end
    it 'should see a date as a time' do
      time = Date.new(2002, 2, 3)
      expect(described_class.a_time?(time)).to be_truthy
    end
    it 'should see a datetime as a time' do
      # rubocop:disable Style/DateTime
      time = DateTime.new(2012, 8, 29, 22, 35, 0)
      # rubocop:enable Style/DateTime
      expect(described_class.a_time?(time)).to be_truthy
    end
    it 'should not see anything else as a time' do
      expect(described_class.a_time?('ando')).to be_falsey
      expect(described_class.a_time?(42)).to be_falsey
      expect(described_class.a_time?([1, 2, 3])).to be_falsey
      expect(described_class.a_time?(%w[ab c d])).to be_falsey
      expect(described_class.a_time?(a: 'hoi', b: 'doei', c: 13)).to be_falsey
      expect(described_class.a_time?(1.minute)).to be_falsey
    end
  end

  describe 'an_offset?' do
    it 'should see an active support duration as an offset' do
      offset = 1.minute
      expect(described_class.an_offset?(offset)).to be_truthy
    end
    it 'should see an integer as an offset' do
      offset = 15
      expect(described_class.an_offset?(offset)).to be_truthy
    end
    it 'should not see anything else as an offset' do
      # time date datetime, activesupport time with zone
      expect(described_class.an_offset?('ando')).to be_falsey
      expect(described_class.an_offset?([1, 2, 3])).to be_falsey
      expect(described_class.an_offset?(%w[ab c d])).to be_falsey
      expect(described_class.an_offset?(a: 'hoi', b: 'doei', c: 13)).to be_falsey
      expect(described_class.an_offset?(Time.zone.now)).to be_falsey
      expect(described_class.an_offset?(Date.new(2002, 2, 3))).to be_falsey
      expect(described_class.an_offset?(Time.new(2002))).to be_falsey
      # rubocop:disable Style/DateTime
      expect(described_class.an_offset?(DateTime.new(2012, 8, 29, 22, 35, 0))).to be_falsey
      # rubocop:enable Style/DateTime
    end
  end
end
