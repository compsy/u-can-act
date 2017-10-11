# frozen_string_literal: true

require 'rails_helper'

describe Measurement do
  it 'should have valid default properties' do
    measurement = FactoryGirl.build(:measurement)
    expect(measurement.valid?).to be_truthy
  end

  describe 'questionnaire_id' do
    it 'should have one' do
      measurement = FactoryGirl.build(:measurement, questionnaire_id: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :questionnaire_id
      expect(measurement.errors.messages[:questionnaire_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Questionnaire' do
      measurement = FactoryGirl.create(:measurement)
      expect(measurement.questionnaire).to be_a(Questionnaire)
    end
  end

  describe 'protocol_id' do
    it 'should have one' do
      measurement = FactoryGirl.build(:measurement, protocol_id: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :protocol_id
      expect(measurement.errors.messages[:protocol_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Protocol' do
      measurement = FactoryGirl.create(:measurement)
      expect(measurement.protocol).to be_a(Protocol)
    end
  end

  describe 'open_from_offset' do
    it 'should be an integer' do
      measurement = FactoryGirl.build(:measurement)
      measurement.open_from_offset = 5
      expect(measurement.valid?).to be_truthy
      measurement.open_from_offset = -3
      expect(measurement.valid?).to be_truthy
      measurement.open_from_offset = 0
      expect(measurement.valid?).to be_truthy
      measurement.open_from_offset = 1.5
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :open_from_offset
      expect(measurement.errors.messages[:open_from_offset]).to include('moet een geheel getal zijn')
    end
    it 'should not be nil' do
      measurement = FactoryGirl.build(:measurement, open_from_offset: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :open_from_offset
      expect(measurement.errors.messages[:open_from_offset]).to include('is geen getal')
    end
  end

  describe 'period' do
    it 'should be a zero or positive integer' do
      measurement = FactoryGirl.build(:measurement)
      measurement.period = 0
      expect(measurement.valid?).to be_truthy
      measurement.period = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :period
      expect(measurement.errors.messages[:period]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should accept nil values' do
      measurement = FactoryGirl.build(:measurement, period: nil)
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'open_duration' do
    it 'should be a zero or positive integer' do
      measurement = FactoryGirl.build(:measurement)
      measurement.open_duration = 0
      expect(measurement.valid?).to be_truthy
      measurement.open_duration = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :open_duration
      expect(measurement.errors.messages[:open_duration]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should accept nil values' do
      measurement = FactoryGirl.build(:measurement, open_duration: nil)
      expect(measurement.valid?).to be_truthy
    end
  end

  describe 'reward_points' do
    it 'should be a zero or positive integer' do
      measurement = FactoryGirl.build(:measurement)
      measurement.reward_points = 0
      expect(measurement.valid?).to be_truthy
      measurement.reward_points = -1
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should not be nil' do
      measurement = FactoryGirl.build(:measurement, reward_points: nil)
      expect(measurement.valid?).to be_falsey
      expect(measurement.errors.messages).to have_key :reward_points
      expect(measurement.errors.messages[:reward_points]).to include('is geen getal')
    end
  end

  describe 'responses' do
    it 'should delete the responses when destroying the measurement' do
      measurement = FactoryGirl.create(:measurement)
      FactoryGirl.create(:response, measurement: measurement)
      expect(measurement.responses.first).to be_a(Response)
      responsecountbefore = Response.count
      measurement.destroy
      expect(Response.count).to eq(responsecountbefore - 1)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      measurement = FactoryGirl.create(:measurement)
      expect(measurement.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(measurement.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
