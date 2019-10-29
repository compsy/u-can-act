# frozen_string_literal: true

require 'rails_helper'

describe Person do
  it_behaves_like 'a person object'

  describe 'last_completed_response' do
    it 'returns nil if no response has been completed so far' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      expect(person.protocol_subscriptions.first.responses).not_to(be_any(&:completed?))
      expect(person.last_completed_response).to be_nil
    end

    it 'returns nil if the person does not have any protocol subscriptions' do
      person = FactoryBot.create(:person)
      expect(person.protocol_subscriptions).to be_blank
      expect(person.last_completed_response).to be_nil
    end
    it 'returns the last completed response' do
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

      expect(person.protocol_subscriptions.first.responses).not_to be_nil
      expect(person.protocol_subscriptions.first.responses.length).to eq 2 * max_idx
      expect(person.last_completed_response).not_to be_nil
      expect(person.last_completed_response).to eq expected_response
    end

    it 'returns the last completed response if a person has multiple protocol subscriptions' do
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

      expect(person.last_completed_response).not_to be_nil
      expect(person.last_completed_response).to eq expected_response
    end
  end

  describe 'stats' do
    let(:person) { FactoryBot.create(:person) }

    it 'returns a hash with the correct keys' do
      result = person.stats(5, 2017, 50)
      expect(result).to be_a Hash
      expect(result.keys).to match_array %i[met_threshold_completion completed total]
    end

    it 'calculates the correct stats' do
      subscription = FactoryBot.create(:protocol_subscription, person: person)
      number_missed = 1
      number_completed = 2

      # Two completed responses, and one missed one
      FactoryBot.create_list(:response, number_completed, :completed,
                             protocol_subscription: subscription,
                             open_from: Time.new(2017, 2, 2, 0, 0, 0).in_time_zone)

      FactoryBot.create_list(:response, number_missed,
                             protocol_subscription: subscription,
                             open_from: Time.new(2017, 2, 2, 0, 0, 0).in_time_zone)
      result = person.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 1
      expect(result[:completed]).to eq number_completed
      expect(result[:total]).to eq number_completed + number_missed
    end

    it 'does not take into account the non-active protocol subscriptions' do
      number_missed = 1
      number_completed = 2
      subscriptions = [FactoryBot.create(:protocol_subscription, person: person),
                       FactoryBot.create(:protocol_subscription, :canceled, person: person)]

      subscriptions.each do |subscription|
        FactoryBot.create_list(:response, number_completed, :completed,
                               protocol_subscription: subscription,
                               open_from: Time.new(2017, 2, 2, 0, 0, 0).in_time_zone)
        FactoryBot.create_list(:response, number_missed, protocol_subscription: subscription,
                                                         open_from: Time.new(2017, 2, 2, 0, 0, 0).in_time_zone)
      end

      result = person.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 1
      expect(result[:completed]).to eq number_completed
      expect(result[:total]).to eq number_completed + number_missed
    end

    it 'returns only zeros if there are no subscriptions' do
      result = person.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 0
      expect(result[:completed]).to eq 0
      expect(result[:total]).to eq 0
    end
  end
end
