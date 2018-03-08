# frozen_string_literal: true

require 'rails_helper'

describe Person do
  it_should_behave_like 'a person object'

  describe 'last_completed_response' do
    it 'should return nil if no response has been completed so far' do
      raise
    end
    it 'should return the last completed response' do
      raise
    end

    it 'should return the last completed response if a person has multiple protocol subscriptions' do
      raise
    end
  end

  describe 'stats' do
    it 'should return a hash with the correct keys' do
      person = FactoryBot.create(:person)
      result = person.stats(5, 2017, 50)
      expect(result).to be_a Hash
      expect(result.keys).to match_array %i[met_threshold_completion completed total]
    end

    it 'should calculate the correct stats' do
      person = FactoryBot.create(:person)
      subscription = FactoryBot.create(:protocol_subscription)
      mock_response = double('response')
      allow(mock_response).to receive(:completed).and_return([1, 1])
      allow(mock_response).to receive(:count).and_return(3)

      mock_responses = double('responses')
      allow(mock_responses).to receive(:in_week).with(week_number: 5, year: 2017).and_return(mock_response)
      expect(subscription).to receive(:responses).and_return(mock_responses)
      person.protocol_subscriptions << subscription

      result = person.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 1
      expect(result[:completed]).to eq 2
      expect(result[:total]).to eq 3
    end

    it 'should return only zeros if there are no subscriptions' do
      person = FactoryBot.create(:person)
      result = person.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 0
      expect(result[:completed]).to eq 0
      expect(result[:total]).to eq 0
    end
  end
end
