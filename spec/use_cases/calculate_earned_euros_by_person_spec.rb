# frozen_string_literal: true

require 'rails_helper'

describe CalculateEarnedEurosByPerson do
  describe 'run!' do
    let(:person) { FactoryBot.create(:person) }
    it 'should calculate the sum over all earned euros of all protocol subscriptions' do
      reward = 30
      number_of_subs = 3
      protocol = FactoryBot.create(:protocol)
      allow_any_instance_of(ProtocolSubscription)
        .to receive(:earned_euros)
        .with(no_args)
        .and_return(reward)

      number_of_subs.times do |_x|
        FactoryBot.create(:protocol_subscription,
                          protocol: protocol,
                          person: person)
      end

      result = described_class.run!(person: person)
      expect(result).to eq number_of_subs * reward
    end

    it 'should also take canceled subs into account' do
      protocol = FactoryBot.create(:protocol, :with_rewards)
      3.times do |_x|
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  :canceled,
                                                  protocol: protocol,
                                                  person: person,
                                                  start_date: 10.days.ago.beginning_of_day)
        (1..7).map do |day|
          FactoryBot.create(:response,
                            :completed,
                            protocol_subscription: protocol_subscription,
                            open_from: day.days.ago.in_time_zone)
          FactoryBot.create(:response,
                            protocol_subscription: protocol_subscription,
                            open_from: day.days.from_now.in_time_zone)
        end
      end
      result = described_class.run!(person: person)
      expect(result - 0.21).to be < 0.0001
    end

    it 'should only look at protocol subscriptions one fills out for him / herself ' do
      protocol = FactoryBot.create(:protocol, :with_rewards)
      other_person = FactoryBot.create(:person)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                filling_out_for_id: other_person.id,
                                                protocol: protocol,
                                                person: person,
                                                start_date: 10.days.ago.beginning_of_day)
      (1..7).map do |day|
        FactoryBot.create(:response,
                          :completed,
                          protocol_subscription: protocol_subscription,
                          open_from: day.days.ago.in_time_zone)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: day.days.from_now.in_time_zone)
      end
      result = described_class.run!(person: person)
      expect(result).to be 0
    end

    it 'should return 0 if there werent any protocol subscriptions' do
      result = described_class.run!(person: person)
      expect(person.protocol_subscriptions).to be_blank
      expect(result).to be 0
    end
  end
end
