# frozen_string_literal: true

require 'rails_helper'

describe PreviewProtocol do
  let(:protocol) { FactoryBot.create(:protocol) }
  let!(:measurement) do
    FactoryBot.create(:measurement,
                      period: 1.day,
                      open_from_offset: 0,
                      protocol: protocol)
  end

  it 'returns the correct results' do
    # Some date in the future
    start_date = Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone
    end_date = TimeTools.increase_by_duration(start_date, 1.week)
    expected_times = [start_date,
                      TimeTools.increase_by_duration(start_date, 1.day),
                      TimeTools.increase_by_duration(start_date, 2.days),
                      TimeTools.increase_by_duration(start_date, 3.days),
                      TimeTools.increase_by_duration(start_date, 4.days),
                      TimeTools.increase_by_duration(start_date, 5.days),
                      TimeTools.increase_by_duration(start_date, 6.days)]
    result = described_class.run!(protocol: protocol,
                                  future: 10.minutes.ago,
                                  start_date: start_date,
                                  end_date: end_date)
    expect(result.length).to eq(expected_times.length)
    result.each_with_index do |entry, idx|
      expected_time = expected_times[idx]
      expect(entry).to match({ open_from: within(1.second).of(expected_time),
                               questionnaire: measurement.questionnaire.key })
    end
  end

  it 'works when not specifying end date' do
    start_date = Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone
    end_date = TimeTools.increase_by_duration(start_date, protocol.duration)
    expect_any_instance_of(Measurement).to receive(:response_times).with(start_date,
                                                                         within(1.second).of(end_date),
                                                                         false).and_call_original
    described_class.run!(protocol: protocol, future: 10.minutes.ago, start_date: start_date, end_date: nil)
  end

  it 'passes the open_from_day_uses_start_date_offset value' do
    start_date = Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone
    end_date = TimeTools.increase_by_duration(start_date, protocol.duration)
    expect_any_instance_of(Measurement).to receive(:response_times).with(start_date,
                                                                         within(1.second).of(end_date),
                                                                         true).and_call_original
    described_class.run!(protocol: protocol,
                         future: 10.minutes.ago,
                         start_date: start_date,
                         open_from_day_uses_start_date_offset: true)
  end
end
