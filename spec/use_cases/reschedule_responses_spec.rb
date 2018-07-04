# frozen_string_literal: true

require 'rails_helper'

describe RescheduleResponses do
  describe 'execute' do
    let!(:protocol_subscription) { FactoryBot.create(:protocol_subscription) }
    it 'should run everything inside a transaction' do
      expect(ActiveRecord::Base).to receive(:transaction) do |_options, &block|
        block.call # cannot set isolation level in nested transaction.
      end
      described_class.run!(protocol_subscription: protocol_subscription)
    end

    describe 'should destroy all future responses' do
      it 'with the default future date' do
        future = TimeTools.increase_by_duration(Time.zone.now, 3.hours)
        responses = []
        responses << FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  open_from: future - 2.days)
        responses << FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  open_from: future - 1.day)
        FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                     open_from: future)
        FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                     open_from: future + 1.day, completed_at: Time.new(2018, 10, 10))
        described_class.run!(protocol_subscription: protocol_subscription)
        responses.zip(Response.all).each do |local_response, other_response|
          expect(local_response).to eq other_response
        end
      end

      it 'with the default future date' do
        protocol = FactoryBot.create(:protocol, duration: 5.weeks)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        Response.destroy_all
        described_class.run!(protocol_subscription: protocol_subscription)
        expect(Response.count).to eq(4)
      end

      it 'with a different future date' do
        protocol = FactoryBot.create(:protocol, duration: 5.weeks)
        FactoryBot.create(:measurement, :periodical, protocol: protocol)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  start_date: 1.week.ago.at_beginning_of_day)

        future = TimeTools.increase_by_duration(Time.zone.now, 1.week)
        responses = Response.all.to_a
        described_class.run!(protocol_subscription: protocol_subscription, future: future)
        expect(responses.first).to eq Response.first

        responses.last(3).zip(Response.last(3)).each do |local_response, other_response|
          expect(local_response).to_not eq other_response
        end
      end
    end

    it 'should reschedule future responses ' do
      protocol = FactoryBot.create(:protocol, duration: 5.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: 1.week.ago.at_beginning_of_day)
      Response.destroy_all
      future = Time.new(2017, 10, 11)
      times = [Time.new(2017, 10, 10), Time.new(2017, 10, 11), Time.new(2017, 10, 12), Time.new(2017, 10, 13)]
      expect_any_instance_of(Measurement).to receive(:response_times).with(protocol_subscription.start_date,
                                                                           protocol_subscription.end_date)
                                                                     .and_return(times)
      expect(Response.count).to eq(0)
      described_class.run!(protocol_subscription: protocol_subscription, future: future)
      expect(Response.count).to eq(2)
    end
  end
end
