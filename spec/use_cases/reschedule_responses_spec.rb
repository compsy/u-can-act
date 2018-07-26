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

    describe 'rescheduling single time measurements' do
      let(:protocol) { FactoryBot.create(:protocol, duration: 5.weeks) }
      let!(:measurement) do
        FactoryBot.create(:measurement, protocol: protocol,
                                        open_from_offset: nil,
                                        offset_till_end: 2.days + 12.hours,
                                        period: nil,
                                        open_duration: nil,
                                        reward_points:  0,
                                        stop_measurement: true,
                                        should_invite: true,
                                        redirect_url: '/person/edit')
      end

      let!(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          protocol: protocol,
                          start_date: 1.week.ago.at_beginning_of_day,
                          end_date: 3.days.from_now)
      end
      before :each do
        Timecop.freeze(2018, 7, 26)
      end

      after :each do
        Timecop.return
      end

      it 'should reschedule not future responses for non periodical measurements if they is one completed ' do
        # Using the student nameting as an example
        Response.destroy_all

        # Create finished response
        finished_response = Response.create!(protocol_subscription_id: protocol_subscription.id,
                                             measurement_id: measurement.id,
                                             completed_at: 7.days.ago.in_time_zone,
                                             open_from: 8.days.ago.in_time_zone)

        expect_any_instance_of(Measurement).to receive(:response_times).with(
          protocol_subscription.start_date,
          protocol_subscription.end_date
        ).and_call_original

        expect(Response.count).to eq(1)
        described_class.run!(protocol_subscription: protocol_subscription)
        expect(Response.count).to eq(1)
        expect(Response.all.first).to eq finished_response
      end

      it 'should reschedule future responses for non periodical measurements if there are none completed ' do
        Response.destroy_all

        expect_any_instance_of(Measurement).to receive(:response_times).with(
          protocol_subscription.start_date,
          protocol_subscription.end_date
        ).and_call_original

        expect(Response.count).to eq(0)
        described_class.run!(protocol_subscription: protocol_subscription)
        expect(Response.count).to eq(1)
        expect(Response.all.first.measurement).to eq measurement
        expect(Response.all.first.protocol_subscription).to eq protocol_subscription
      end

      it 'should reschedule not future responses for non periodical measurements if they is one completed ' do
        protocol.reload
        protocol.measurements.destroy_all
        measurement = FactoryBot.create(:measurement, :periodical,
                                        protocol: protocol,
                                        open_duration: 10.weeks,
                                        reward_points:  0,
                                        should_invite: true,
                                        redirect_url: '/person/edit')
        Response.destroy_all

        protocol.reload
        expect(protocol.measurements.length).to eq 1

        # Create finished response
        finished_response = Response.create!(protocol_subscription_id: protocol_subscription.id,
                                             measurement_id: measurement.id,
                                             completed_at: 7.days.ago.in_time_zone,
                                             open_from: 8.days.ago.in_time_zone)

        expect_any_instance_of(Measurement).to receive(:response_times).with(
          protocol_subscription.start_date,
          protocol_subscription.end_date
        ).and_call_original

        expect(Response.count).to eq(1)
        expect(protocol_subscription.responses.count).to eq(1)

        described_class.run!(protocol_subscription: protocol_subscription)
        expect(Response.count).to eq(2)
        expect(Response.all.first.protocol_subscription).to eq protocol_subscription
        expect(Response.all.second.protocol_subscription).to_not eq protocol_subscription
      end
    end
  end
end
