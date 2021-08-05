# frozen_string_literal: true

require 'rails_helper'

describe ProtocolHelper do
  describe 'start_date' do
    it 'works when the start date is blank' do
      expect(helper.start_date('')).to be_within(1.second).of(Time.zone.now)
      expect(helper.start_date(nil)).to be_within(1.second).of(Time.zone.now)
    end
    it 'uses the current time when the given time is in the past' do
      cur_start_date = Time.new(2017, 10, 10).in_time_zone
      expect(helper.start_date(cur_start_date.to_s)).to be_within(1.second).of(Time.zone.now)
    end
    it 'uses the given time when the given time is in the future' do
      cur_start_date = Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone
      expect(helper.start_date(cur_start_date.to_s)).to be_within(1.second).of(cur_start_date)
    end
  end

  describe 'end_date' do
    let!(:cur_start_date) { Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone }

    it 'returns nil if the end date is blank' do
      expect(helper.end_date(cur_start_date.to_s, nil)).to be_nil
      expect(helper.end_date(cur_start_date.to_s, '')).to be_nil
    end
    it 'returns start_date + 1 hour when the end date is before the start date + 1 hour' do
      expect(helper.end_date(cur_start_date.to_s, Time.zone.now.to_s)).to(
        be_within(1.second).of(TimeTools.increase_by_duration(cur_start_date, 1.hour))
      )
    end
    it 'works when the end date is after the start date + 1 hour' do
      cur_end_date = TimeTools.increase_by_duration(cur_start_date, 3.weeks)
      expect(helper.end_date(cur_start_date.to_s, cur_end_date.to_s)).to be_within(1.second).of(cur_end_date)
    end
  end
end
