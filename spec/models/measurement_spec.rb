# frozen_string_literal: true

require 'rails_helper'

describe Measurement do
  it 'has valid default properties' do
    measurement = FactoryBot.create(:measurement)
    expect(measurement).to be_valid
  end

  describe 'reminder_delay' do
    it 'should have a default reminder delay of 8.hours' do
      measurement = FactoryBot.build(:measurement)
      expect(measurement.reminder_delay).to eq described_class::DEFAULT_REMINDER_DELAY
      expect(Measurement::DEFAULT_REMINDER_DELAY).to eq 8.hours
    end

    it 'should be an integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.reminder_delay = 5
      expect(measurement.valid?).to be_truthy
      measurement.reminder_delay = -3
      expect(measurement.valid?).to be_falsey
      measurement.reminder_delay = 0
      expect(measurement.valid?).to be_truthy
      measurement.reminder_delay = 1.5
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :reminder_delay
      expect(measurement.errors.messages[:reminder_delay]).to include('moet een geheel getal zijn')
    end

    it 'can be nil' do
      measurement = FactoryBot.create(:measurement)
      measurement.reminder_delay = nil
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'questionnaire_id' do
    it 'has one' do
      measurement = FactoryBot.create(:measurement)
      measurement.questionnaire_id = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :questionnaire_id
      expect(measurement.errors.messages[:questionnaire_id]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a Questionnaire' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.questionnaire).to be_a(Questionnaire)
    end
  end

  describe 'protocol_id' do
    it 'has one' do
      measurement = FactoryBot.create(:measurement)
      measurement.protocol_id = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :protocol_id
      expect(measurement.errors.messages[:protocol_id]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a Protocol' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.protocol).to be_a(Protocol)
    end
  end

  describe 'open_from_offset' do
    it 'is an integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_from_offset = 5
      expect(measurement).to be_valid
      measurement.open_from_offset = -3
      expect(measurement).not_to be_valid
      measurement.open_from_offset = 0
      expect(measurement).to be_valid
      measurement.open_from_offset = 1.5
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :open_from_offset
      expect(measurement.errors.messages[:open_from_offset]).to include('moet een geheel getal zijn')
    end
    it 'is able to be nil as long as offset_till_end is set' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_from_offset = nil
      expect(measurement).not_to be_valid
      measurement = FactoryBot.create(:measurement, open_from_offset: nil, offset_till_end: 1.week)
      expect(measurement).to be_valid
    end
  end

  describe 'open_from_day' do
    it 'is a day of the week' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_from_day = 'saturday'
      expect(measurement).to be_valid
      measurement.open_from_day = 'gehaktdag'
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :open_from_day
      expect(measurement.errors.messages[:open_from_day]).to include('is niet in de lijst opgenomen')
    end
    it 'is able to be nil' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_from_day = nil
      expect(measurement).to be_valid
    end
  end

  describe 'stop_measurement' do
    it 'is false by default' do
      measurement = described_class.new
      expect(measurement).not_to be_stop_measurement
    end
    it 'is present and boolean' do
      measurement = FactoryBot.create(:measurement)
      measurement.stop_measurement = nil
      expect(measurement).not_to be_valid

      measurement.stop_measurement = true
      expect(measurement).to be_valid
      measurement.stop_measurement = false
      expect(measurement).to be_valid
    end
    it 'sets the correct error messages' do
      measurement = FactoryBot.create(:measurement)
      measurement.stop_measurement = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :stop_measurement
      expect(measurement.errors.messages[:stop_measurement]).to include('is niet in de lijst opgenomen')
    end

    it 'is not allowed to have two stop_measurements in one prototcol' do
      expect(described_class.count).to eq 0
      protocol = FactoryBot.create(:protocol)
      measurement = FactoryBot.create(:measurement, stop_measurement: true, protocol: protocol)
      expect(measurement).to be_valid
      measurement2 = FactoryBot.create(:measurement, protocol: protocol)
      measurement2.stop_measurement = true
      expect(measurement2).not_to be_valid
      expect(measurement2.errors.messages.keys).to include(:protocol)
      expect(measurement2.errors.messages[:protocol]).to include('can only have a single stop_measurement')
      expect(described_class.count).to eq 2 # the original it created was valid
    end

    it 'is not allowed to have multiple measurements in one prototcol' do
      expect(described_class.count).to eq 0
      protocol = FactoryBot.create(:protocol)
      measurement = FactoryBot.create(:measurement, stop_measurement: true, protocol: protocol)
      expect(measurement).to be_valid
      measurement = FactoryBot.create(:measurement, stop_measurement: false, protocol: protocol)
      expect(measurement).to be_valid
      measurement = FactoryBot.create(:measurement, stop_measurement: false, protocol: protocol)
      expect(measurement).to be_valid
      expect(described_class.count).to eq 3
    end
  end

  describe 'should_invite' do
    it 'is true by default' do
      measurement = described_class.new
      expect(measurement).to be_should_invite
    end
    it 'is present and boolean' do
      measurement = FactoryBot.create(:measurement)
      measurement.should_invite = nil
      expect(measurement).not_to be_valid

      measurement.should_invite = true
      expect(measurement).to be_valid
      measurement.should_invite = false
      expect(measurement).to be_valid
    end
    it 'sets the correct error messages' do
      measurement = FactoryBot.create(:measurement)
      measurement.should_invite = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :should_invite
      expect(measurement.errors.messages[:should_invite]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'priority' do
    it 'is an integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.priority = 2
      expect(measurement).to be_valid
      measurement.priority = 0
      expect(measurement).to be_valid
      measurement.priority = -1
      expect(measurement).to be_valid
      measurement.priority = 1.5
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :priority
      expect(measurement.errors.messages[:priority]).to include('moet een geheel getal zijn')
    end
    it 'accepts nil values' do
      measurement = FactoryBot.create(:measurement, priority: nil)
      expect(measurement).to be_valid
    end
  end

  describe 'period' do
    it 'is a positive integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.period = 2
      expect(measurement).to be_valid
      measurement.period = 0
      expect(measurement).not_to be_valid
      measurement.period = 1.5
      expect(measurement).not_to be_valid
      measurement.period = -1
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :period
      expect(measurement.errors.messages[:period]).to include('moet groter zijn dan 0')
    end
    it 'accepts nil values' do
      measurement = FactoryBot.create(:measurement, period: nil)
      expect(measurement).to be_valid
    end
  end

  describe 'open_duration' do
    it 'is a zero or positive integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_duration = 0
      expect(measurement).to be_valid
      measurement.open_duration = 1.5
      expect(measurement).not_to be_valid
      measurement.open_duration = -1
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :open_duration
      expect(measurement.errors.messages[:open_duration]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'accepts nil values' do
      measurement = FactoryBot.create(:measurement, open_duration: nil)
      expect(measurement).to be_valid
    end
  end

  describe 'offset_till_end' do
    it 'is a zero or positive integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.open_from_offset = nil
      measurement.offset_till_end = 0
      expect(measurement).to be_valid
      measurement.offset_till_end = 1.5
      expect(measurement).not_to be_valid
      measurement.offset_till_end = -1
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :offset_till_end
      expect(measurement.errors.messages[:offset_till_end]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'accepts nil values' do
      measurement = FactoryBot.create(:measurement, open_duration: nil)
      expect(measurement).to be_valid
    end
  end

  describe 'reward_points' do
    it 'is a zero or positive integer' do
      measurement = FactoryBot.create(:measurement)
      measurement.reward_points = 0
      expect(measurement).to be_valid
      measurement.reward_points = 1.5
      expect(measurement).not_to be_valid
      measurement.reward_points = -1
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'is not nil' do
      measurement = FactoryBot.create(:measurement)
      measurement.reward_points = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('is geen getal')
    end
  end

  describe 'responses' do
    it 'deletes the responses when destroying the measurement' do
      measurement = FactoryBot.create(:measurement)
      FactoryBot.create(:response, measurement: measurement)
      expect(measurement.responses.first).to be_a(Response)
      responsecountbefore = Response.count
      measurement.destroy
      expect(Response.count).to eq(responsecountbefore - 1)
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(measurement.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'redirect_url' do
    it 'has a redirect url' do
      measurement = FactoryBot.create(:measurement, redirect_url: 'test')
      expect(measurement.redirect_url).to eq('test')
    end
  end

  describe 'response_times' do
    context 'periodical measurements' do
      it 'works if there is an offset_till_end present' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, period: 1.day, open_from_offset: 0, offset_till_end: 2.days)
        expected_times = [start_date,
                          TimeTools.increase_by_duration(start_date, 1.day),
                          TimeTools.increase_by_duration(start_date, 2.days),
                          TimeTools.increase_by_duration(start_date, 3.days),
                          TimeTools.increase_by_duration(start_date, 4.days)]
        expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
      end
      it 'works if there is is not an offset_till_end present' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, period: 1.day, open_from_offset: 0, offset_till_end: nil)
        expected_times = [start_date,
                          TimeTools.increase_by_duration(start_date, 1.day),
                          TimeTools.increase_by_duration(start_date, 2.days),
                          TimeTools.increase_by_duration(start_date, 3.days),
                          TimeTools.increase_by_duration(start_date, 4.days),
                          TimeTools.increase_by_duration(start_date, 5.days),
                          TimeTools.increase_by_duration(start_date, 6.days)]
        expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
      end
    end

    context 'nonperiodical measurements' do
      it 'works with only an open_from_offset' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, open_from_offset: 3.days, offset_till_end: nil)
        expected_times = [TimeTools.increase_by_duration(start_date, 3.days)]
        expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
      end
      context 'open_from_day' do
        context 'when open_from_day_uses_start_date_offset is false' do
          it 'works' do
            start_date = Time.new(2017, 10, 10, 7).in_time_zone
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'saturday')
            expected_times = [TimeTools.increase_by_duration(start_date, 4.days + 12.hours - 7.hours)]
            expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
          end
          it 'works for measurements on the same day' do
            start_date = Time.new(2017, 10, 10, 7).in_time_zone
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'tuesday')
            expected_times = [TimeTools.increase_by_duration(start_date, 12.hours - 7.hours)]
            expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
          end
          it 'reschedules measurements on the same day but before the start date one week in the future' do
            start_date = Time.new(2017, 10, 10, 15).in_time_zone
            # Note that it doesn't use the end date in its calculations since the measurement is not periodic.
            # The returned response time is actually after the end_date.
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'tuesday')
            expected_times = [TimeTools.increase_by_duration(start_date.beginning_of_day, 7.days + 12.hours)]
            expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
          end
        end
        context 'when open_from_day_uses_start_date_offset is true' do
          it 'works' do
            start_date = Time.new(2017, 10, 10, 7).in_time_zone
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            # it now ignores the 12.hours and usees the 7.hours from the start date as offset.
            # hence when we increase the start date by exactly 4.days we get 7am on saturday.
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'saturday')
            expected_times = [TimeTools.increase_by_duration(start_date, 4.days)]
            expect(measurement.response_times(start_date, end_date, true)).to eq expected_times
          end
          it 'works for measurements on the same day' do
            start_date = Time.new(2017, 10, 10, 7).in_time_zone
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            # 2017-10-10 is a tuesday so we start the measurement right at the start date (ignoring
            # the open_from_offset because open_from_day_uses_start_date_offset is true).
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'tuesday')
            expected_times = [start_date]
            expect(measurement.response_times(start_date, end_date, true)).to eq expected_times
          end
          it 'reschedules measurements on the same day but before the start date at the start date' do
            start_date = Time.new(2017, 10, 10, 15).in_time_zone
            end_date = TimeTools.increase_by_duration(start_date, 1.week)
            measurement = FactoryBot.create(:measurement, open_from_offset: 12.hours, open_from_day: 'tuesday')
            expected_times = [start_date]
            expect(measurement.response_times(start_date, end_date, true)).to eq expected_times
          end
        end
      end
      it 'works with only an offset_till_end' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, open_from_offset: nil, offset_till_end: 5.days)
        expected_times = [TimeTools.increase_by_duration(start_date, 2.days)]
        expect(measurement.response_times(start_date, end_date, false)).to eq expected_times
      end
    end
  end

  describe 'validations' do
    context 'either_open_from_or_offset_till_end' do
      describe 'periodical measurements' do
        it 'does not work without an open_from_offset' do
          measurement = FactoryBot.create(:measurement, :periodical)
          measurement.open_from_offset = nil
          expect(measurement).not_to be_valid
          expect(measurement.errors.messages).to have_key :open_from_offset
          expect(measurement.errors.messages[:open_from_offset]).to include('cannot be blank')
        end
      end

      describe 'nonperiodical measurements' do
        it 'works with only open_from_offset' do
          measurement = FactoryBot.create(:measurement, open_from_offset: 1.week, offset_till_end: nil)
          expect(measurement).to be_valid
        end
        it 'works with only offset_till_end' do
          measurement = FactoryBot.create(:measurement, offset_till_end: 1.week, open_from_offset: nil)
          expect(measurement).to be_valid
        end
        it 'fails validation with both open_from_offset and open_till_end' do
          measurement = FactoryBot.create(:measurement)
          measurement.offset_till_end = 1.week
          measurement.open_from_offset = 1.week
          expect(measurement).not_to be_valid
          expect(measurement.errors.messages).to have_key :open_from_offset
          expect(measurement.errors.messages[:open_from_offset])
            .to include('cannot be present if offset_till_end is present')
          expect(measurement.errors.messages).to have_key :offset_till_end
          expect(measurement.errors.messages[:offset_till_end])
            .to include('cannot be present if open_from_offset is present')
        end
        it 'fails validation with neither open_from_offset or open_till_end' do
          measurement = FactoryBot.create(:measurement)
          measurement.offset_till_end = nil
          measurement.open_from_offset = nil
          expect(measurement).not_to be_valid
          expect(measurement.errors.messages).to have_key :open_from_offset
          expect(measurement.errors.messages[:open_from_offset])
            .to include('cannot be blank if offset_till_end is blank')
          expect(measurement.errors.messages).to have_key :offset_till_end
          expect(measurement.errors.messages[:offset_till_end])
            .to include('cannot be blank if open_from_offset is blank')
        end
      end
    end
  end
end
