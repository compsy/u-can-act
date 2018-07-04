# frozen_string_literal: true

require 'rails_helper'

describe Measurement do
  it 'should have valid default properties' do
    measurement = FactoryBot.build(:measurement)
    expect(measurement.valid?).to be_truthy
  end

  describe 'questionnaire_id' do
    it 'should have one' do
      measurement = FactoryBot.build(:measurement, questionnaire_id: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :questionnaire_id
      expect(measurement.errors.messages[:questionnaire_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Questionnaire' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.questionnaire).to be_a(Questionnaire)
    end
  end

  describe 'protocol_id' do
    it 'should have one' do
      measurement = FactoryBot.build(:measurement, protocol_id: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :protocol_id
      expect(measurement.errors.messages[:protocol_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Protocol' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.protocol).to be_a(Protocol)
    end
  end

  describe 'open_from_offset' do
    it 'should be an integer' do
      measurement = FactoryBot.build(:measurement)
      measurement.open_from_offset = 5
      expect(measurement.valid?).to be_truthy
      measurement.open_from_offset = -3
      expect(measurement.valid?).to be_falsey
      measurement.open_from_offset = 0
      expect(measurement.valid?).to be_truthy
      measurement.open_from_offset = 1.5
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :open_from_offset
      expect(measurement.errors.messages[:open_from_offset]).to include('moet een geheel getal zijn')
    end
    it 'should be able to be nil as long as offset_till_end is set' do
      measurement = FactoryBot.build(:measurement, open_from_offset: nil)
      expect(measurement).to_not be_valid
      measurement = FactoryBot.build(:measurement, open_from_offset: nil, offset_till_end: 1.week)
      expect(measurement).to be_valid
    end
  end

  describe 'stop_measurement' do
    it 'should be false by default' do
      measurement = Measurement.new
      expect(measurement.stop_measurement?).to be_falsey
    end
    it 'should be present and boolean' do
      measurement = FactoryBot.build(:measurement)
      measurement.stop_measurement = nil
      expect(measurement).to_not be_valid

      measurement.stop_measurement = true
      expect(measurement).to be_valid
      measurement.stop_measurement = false
      expect(measurement).to be_valid
    end
    it 'should set the correct error messages' do
      measurement = FactoryBot.build(:measurement, stop_measurement: nil)
      expect(measurement).to_not be_valid
      expect(measurement.errors.messages).to have_key :stop_measurement
      expect(measurement.errors.messages[:stop_measurement]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'should_invite' do
    it 'should be true by default' do
      measurement = Measurement.new
      expect(measurement.should_invite?).to be_truthy
    end
    it 'should be present and boolean' do
      measurement = FactoryBot.build(:measurement)
      measurement.should_invite = nil
      expect(measurement).to_not be_valid

      measurement.should_invite = true
      expect(measurement).to be_valid
      measurement.should_invite = false
      expect(measurement).to be_valid
    end
    it 'should set the correct error messages' do
      measurement = FactoryBot.build(:measurement, should_invite: nil)
      expect(measurement).to_not be_valid
      expect(measurement.errors.messages).to have_key :should_invite
      expect(measurement.errors.messages[:should_invite]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'period' do
    it 'should be a positive integer' do
      measurement = FactoryBot.build(:measurement)
      measurement.period = 2
      expect(measurement.valid?).to be_truthy
      measurement.period = 0
      expect(measurement.valid?).to be_falsey
      measurement.period = 1.5
      expect(measurement.valid?).to be_falsey
      measurement.period = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :period
      expect(measurement.errors.messages[:period]).to include('moet groter zijn dan 0')
    end
    it 'should accept nil values' do
      measurement = FactoryBot.build(:measurement, period: nil)
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'open_duration' do
    it 'should be a zero or positive integer' do
      measurement = FactoryBot.build(:measurement)
      measurement.open_duration = 0
      expect(measurement.valid?).to be_truthy
      measurement.open_duration = 1.5
      expect(measurement.valid?).to be_falsey
      measurement.open_duration = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :open_duration
      expect(measurement.errors.messages[:open_duration]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should accept nil values' do
      measurement = FactoryBot.build(:measurement, open_duration: nil)
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'offset_till_end' do
    it 'should be a zero or positive integer' do
      measurement = FactoryBot.build(:measurement, open_from_offset: nil)
      measurement.offset_till_end = 0
      expect(measurement).to be_valid
      measurement.offset_till_end = 1.5
      expect(measurement).to_not be_valid
      measurement.offset_till_end = -1
      expect(measurement).to_not be_valid
      expect(measurement.errors.messages).to have_key :offset_till_end
      expect(measurement.errors.messages[:offset_till_end]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should accept nil values' do
      measurement = FactoryBot.build(:measurement, open_duration: nil)
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'reward_points' do
    it 'should be a zero or positive integer' do
      measurement = FactoryBot.build(:measurement)
      measurement.reward_points = 0
      expect(measurement.valid?).to be_truthy
      measurement.reward_points = 1.5
      expect(measurement.valid?).to be_falsey
      measurement.reward_points = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should not be nil' do
      measurement = FactoryBot.build(:measurement, reward_points: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('is geen getal')
    end
  end

  describe 'responses' do
    it 'should delete the responses when destroying the measurement' do
      measurement = FactoryBot.create(:measurement)
      FactoryBot.create(:response, measurement: measurement)
      expect(measurement.responses.first).to be_a(Response)
      responsecountbefore = Response.count
      measurement.destroy
      expect(Response.count).to eq(responsecountbefore - 1)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      measurement = FactoryBot.create(:measurement)
      expect(measurement.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(measurement.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'redirect_url' do
    it 'should have a redirect url' do
      measurement = FactoryBot.create(:measurement, redirect_url: 'test')
      expect(measurement.redirect_url).to eq('test')
    end
  end

  describe 'response_times' do
    context 'periodical measurements' do
      it 'should work if there is an offset_till_end present' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, period: 1.day, open_from_offset: 0, offset_till_end: 2.days)
        expected_times = [start_date,
                          TimeTools.increase_by_duration(start_date, 1.day),
                          TimeTools.increase_by_duration(start_date, 2.days),
                          TimeTools.increase_by_duration(start_date, 3.days),
                          TimeTools.increase_by_duration(start_date, 4.days)]
        expect(measurement.response_times(start_date, end_date)).to eq expected_times
      end
      it 'should work if there is is not an offset_till_end present' do
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
        expect(measurement.response_times(start_date, end_date)).to eq expected_times
      end
    end
    context 'nonperiodical measurements' do
      it 'should work with only an open_from_offset' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, open_from_offset: 3.days, offset_till_end: nil)
        expected_times = [TimeTools.increase_by_duration(start_date, 3.days)]
        expect(measurement.response_times(start_date, end_date)).to eq expected_times
      end
      it 'should work withonly an offset_till_end' do
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        measurement = FactoryBot.create(:measurement, open_from_offset: nil, offset_till_end: 5.days)
        expected_times = [TimeTools.increase_by_duration(start_date, 2.days)]
        expect(measurement.response_times(start_date, end_date)).to eq expected_times
      end
    end
  end

  describe 'validations' do
    context 'either_open_from_or_offset_till_end' do
      describe 'periodical measurements' do
        it 'should not work without an open_from_offset' do
          measurement = FactoryBot.build(:measurement, :periodical, open_from_offset: nil)
          expect(measurement).to_not be_valid
          expect(measurement.errors.messages).to have_key :open_from_offset
          expect(measurement.errors.messages[:open_from_offset]).to include('cannot be blank')
        end
      end
      describe 'nonperiodical measurements' do
        it 'should work with only open_from_offset' do
          measurement = FactoryBot.build(:measurement, open_from_offset: 1.week, offset_till_end: nil)
          expect(measurement).to be_valid
        end
        it 'should work with only offset_till_end' do
          measurement = FactoryBot.build(:measurement, offset_till_end: 1.week, open_from_offset: nil)
          expect(measurement).to be_valid
        end
        it 'should fail validation with both open_from_offset and open_till_end' do
          measurement = FactoryBot.build(:measurement, offset_till_end: 1.week, open_from_offset: 1.week)
          expect(measurement).to_not be_valid
          expect(measurement.errors.messages).to have_key :open_from_offset
          expect(measurement.errors.messages[:open_from_offset])
            .to include('cannot be present if offset_till_end is present')
          expect(measurement.errors.messages).to have_key :offset_till_end
          expect(measurement.errors.messages[:offset_till_end])
            .to include('cannot be present if open_from_offset is present')
        end
        it 'should fail validation with neither open_from_offset or open_till_end' do
          measurement = FactoryBot.build(:measurement, offset_till_end: nil, open_from_offset: nil)
          expect(measurement).to_not be_valid
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
