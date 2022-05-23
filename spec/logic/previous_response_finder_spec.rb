# frozen_string_literal: true

require 'rails_helper'

describe PreviousResponseFinder do
  describe 'find_value' do
    it 'should return nil if the previous response is not available' do
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement)

      expect(described_class).to receive(:find)
        .with(response)
        .and_return(nil)

      result = described_class.find_value(response, :v1)
      expect(result).to be_nil
    end

    it 'should return nil if the previous response its values are not available' do
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement)

      mock = double('response')
      allow(mock).to receive(:values)
        .and_return({})

      expect(described_class).to receive(:find)
        .with(response)
        .and_return(mock)

      result = described_class.find_value(response, :v1)
      expect(result).to be_nil
    end

    it 'should return nil if the previous response its values do not contain the key' do
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement)

      mock = double('response')
      allow(mock).to receive(:values)
        .and_return(v2: 'hoi')

      expect(described_class).to receive(:find)
        .with(response)
        .and_return(mock)

      result = described_class.find_value(response, :v1)
      expect(result).to be_nil
    end

    it 'should return the previous response its values' do
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement)
      expected = 'hoi'

      mock = double('response')
      allow(mock).to receive(:values)
        .and_return(v1: expected)

      expect(described_class).to receive(:find)
        .with(response)
        .and_return(mock)

      result = described_class.find_value(response, :v1)
      expect(result).to eq expected
    end

    it 'should return the previous response its values' do
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement)
      expected = 'hoi'

      mock = double('response')
      allow(mock).to receive(:values)
        .and_return('v1' => expected)

      expect(described_class).to receive(:find)
        .with(response)
        .and_return(mock)

      result = described_class.find_value(response, :v1)
      expect(result).to eq expected
    end
  end

  describe 'find' do
    it 'should return nil if the provided response is nil' do
      result = described_class.find(nil)
      expect(result).to be_nil
    end

    it 'should return nil if the provided response is not periodcal' do
      response = FactoryBot.create(:response)
      expect(response.measurement.periodical?).to be_falsey

      result = described_class.find(response)
      expect(result).to be_nil
    end

    it 'should return nil if there is no previous response' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      measurement = FactoryBot.create(:measurement, period: 1.day)
      response = FactoryBot.create(:response, measurement: measurement,
                                              protocol_subscription: protocol_subscription)

      result = described_class.find(response)
      expect(result).to be_nil
    end

    it 'should return nil if there is a previous response, but no completed one' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      measurement = FactoryBot.create(:measurement, period: 1.day)
      responses = FactoryBot.create_list(:response, 10, completed_at: nil,
                                                        protocol_subscription: protocol_subscription,
                                                        measurement: measurement)

      result = described_class.find(responses.last)
      expect(result).to be_nil
    end

    it 'should return the response before the last one, if the last one was missed' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      measurement = FactoryBot.create(:measurement, period: 1.day)

      FactoryBot.create(:response,
                        open_from: 13.days.ago,
                        completed_at: 13.days.ago,
                        protocol_subscription: protocol_subscription,
                        measurement: measurement)
      completed_response = FactoryBot.create(:response,
                                             open_from: 12.days.ago,
                                             completed_at: 12.days.ago,
                                             protocol_subscription: protocol_subscription,
                                             measurement: measurement)
      responses = (1..10).map do |idx|
        FactoryBot.create(:response,
                          open_from: idx.days.ago,
                          completed_at: nil,
                          protocol_subscription: protocol_subscription,
                          measurement: measurement)
      end
      result = described_class.find(responses.last)
      expect(result).to eq completed_response
    end

    it 'should return the previous response' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      measurement = FactoryBot.create(:measurement, period: 1.day)

      completed_response = FactoryBot.create(:response,
                                             open_from: 1.day.ago,
                                             completed_at: 1.day.ago,
                                             protocol_subscription: protocol_subscription,
                                             measurement: measurement)
      current_response = FactoryBot.create(:response,
                                           open_from: Time.zone.now,
                                           completed_at: nil,
                                           protocol_subscription: protocol_subscription,
                                           measurement: measurement)
      result = described_class.find(current_response)
      expect(result).to eq completed_response
    end
  end
end
