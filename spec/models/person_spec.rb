# frozen_string_literal: true

require 'rails_helper'

describe Person do
  it_should_behave_like 'a person object'

  describe 'last_completed_response' do
    it 'should return nil if no response has been completed so far' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      expect(person.protocol_subscriptions.first.responses.any?(&:completed?)).to be_falsey
      expect(person.last_completed_response).to be_nil
    end

    it 'should return nil if the person does not have any protocol subscriptions' do
      person = FactoryBot.create(:person)
      expect(person.protocol_subscriptions).to be_blank
      expect(person.last_completed_response).to be_nil
    end
    it 'should return the last completed response' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)

      max_idx = 10
      expected_response = nil
      current_prot_sub = person.protocol_subscriptions.first
      max_idx.times.each do |idx|
        response = FactoryBot.create(:response, completed_at: (10 + idx).days.ago.in_time_zone,
                                                protocol_subscription: current_prot_sub)
        expected_response = response if idx == 0
      end

      # Create some not completed responses as well
      max_idx.times.each do |_idx|
        FactoryBot.create(:response, protocol_subscription: current_prot_sub)
      end

      expect(person.protocol_subscriptions.first.responses).to_not be_nil
      expect(person.protocol_subscriptions.first.responses.length).to eq 2 * max_idx
      expect(person.last_completed_response).to_not be_nil
      expect(person.last_completed_response).to eq expected_response
    end

    it 'should return the last completed response if a person has multiple protocol subscriptions' do
      person = FactoryBot.create(:person)
      FactoryBot.create_list(:protocol_subscription, 10, person: person)

      max_idx = 10
      current_prot_sub = person.protocol_subscriptions[5]
      expected_response = FactoryBot.create(:response, completed_at: 1.day.ago.in_time_zone,
                                                       protocol_subscription: current_prot_sub)

      person.protocol_subscriptions.each do |prot_sub|
        max_idx.times.each do |idx|
          FactoryBot.create(:response, completed_at: (10 + idx).days.ago.in_time_zone,
                                       protocol_subscription: prot_sub)
        end
      end

      person.protocol_subscriptions.each do |prot_sub|
        max_idx.times.each { |_idx| FactoryBot.create(:response, protocol_subscription: prot_sub) }
      end

      expect(person.last_completed_response).to_not be_nil
      expect(person.last_completed_response).to eq expected_response
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
