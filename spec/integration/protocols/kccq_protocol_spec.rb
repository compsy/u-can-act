# frozen_string_literal: true

require 'rails_helper'

describe 'KCCQ Protocol', type: :integration, focus: true do
  let(:protocol) { Protocol.find_by(name: 'kccq') }
  let(:questionnaire) { Questionnaire.find_by(name: 'kccq') }
  let(:person) { FactoryBot.create(:person) }

  before do
    # Create questionnaire first (required by protocol seed)
    load Rails.root.join('projects/sport-data-valley/seeds/questionnaires/kccq.rb')
    # Run the protocol seed file
    load Rails.root.join('projects/sport-data-valley/seeds/protocols/kccq.rb')
  end

  describe 'protocol configuration' do
    it 'exists with correct name' do
      expect(protocol).to be_present
      expect(protocol.name).to eq('kccq')
    end

    it 'has a duration of 5 years' do
      expect(protocol.duration).to eq(5.years)
    end

    it 'has push subscription configured' do
      push_subscription = protocol.push_subscriptions.find_by(name: 'base-platform-subscription-kccq')
      expect(push_subscription).to be_present
      expect(push_subscription.method).to eq('POST')
      expect(push_subscription.url).to eq(ENV.fetch('PUSH_SUBSCRIPTION_URL', nil))
    end
  end

  describe 'measurement configuration' do
    let(:measurement) { protocol.measurements.find_by(questionnaire: questionnaire) }

    it 'has a measurement linked to kccq questionnaire' do
      expect(measurement).to be_present
      expect(measurement.questionnaire).to eq(questionnaire)
    end

    it 'has a period of 6 months' do
      expect(measurement.period).to eq(6.months)
    end

    it 'starts immediately (0 days offset)' do
      expect(measurement.open_from_offset).to eq(0.days)
    end

    it 'has an open duration of 30 days' do
      expect(measurement.open_duration).to eq(30.days)
    end

    it 'should invite participants' do
      expect(measurement.should_invite).to be_truthy
    end

    it 'does not stop measurement' do
      expect(measurement.stop_measurement).to be_falsey
    end

    it 'has no reward points' do
      expect(measurement.reward_points).to eq(0)
    end

    it 'has redirect URL configured' do
      expect(measurement.redirect_url).to eq(ENV.fetch('BASE_PLATFORM_URL', nil))
    end
  end

  describe 'protocol subscription' do
    let!(:protocol_subscription) do
      SubscribeToProtocol.run!(
        protocol: protocol,
        person: person,
        start_date: Time.zone.now
      )
    end

    it 'creates a protocol subscription' do
      expect(protocol_subscription).to be_persisted
      expect(protocol_subscription.protocol).to eq(protocol)
      expect(protocol_subscription.person).to eq(person)
    end

    it 'generates 10 responses over 5 years' do
      # 5 years * 2 (every 6 months) = 10 responses
      expect(protocol_subscription.responses.count).to eq(10)
    end

    it 'schedules responses at 6-month intervals' do
      responses = protocol_subscription.responses.order(:open_from)

      # Check that each response is approximately 6 months apart from the previous
      responses.each_cons(2) do |prev_response, next_response|
        days_between = (next_response.open_from.to_date - prev_response.open_from.to_date).to_i
        # 6 months is approximately 180-185 days, allow some flexibility
        expect(days_between).to be_between(175, 190)
      end
    end

    it 'first response is available immediately' do
      first_response = protocol_subscription.responses.order(:open_from).first
      expect(first_response.open_from.to_date).to eq(Time.zone.now.to_date)
    end

    it 'last response is scheduled approximately 54 months after start' do
      first_response = protocol_subscription.responses.order(:open_from).first
      last_response = protocol_subscription.responses.order(:open_from).last

      days_between = (last_response.open_from.to_date - first_response.open_from.to_date).to_i
      # 54 months is approximately 1620-1650 days, allow some flexibility
      expect(days_between).to be_between(1600, 1670)
    end

    it 'all responses are based on measurement with 30 day open duration' do
      protocol_subscription.responses.each do |response|
        expect(response.measurement.open_duration).to eq(30.days)
      end
    end

    it 'all responses reference the kccq questionnaire' do
      protocol_subscription.responses.each do |response|
        expect(response.measurement.questionnaire).to eq(questionnaire)
      end
    end

    it 'protocol subscription ends after 5 years' do
      end_date = protocol_subscription.end_date
      expected_end_date = protocol_subscription.start_date + 5.years
      expect(end_date).to be_within(1.day).of(expected_end_date)
    end
  end

  describe 'response schedule validation' do
    let!(:protocol_subscription) do
      SubscribeToProtocol.run!(
        protocol: protocol,
        person: person,
        start_date: Time.zone.now
      )
    end

    it 'creates exactly 10 responses over the protocol duration' do
      expect(protocol_subscription.responses.count).to eq(10)
    end

    it 'responses are evenly distributed over 5 years' do
      responses = protocol_subscription.responses.order(:open_from)
      first_date = responses.first.open_from
      last_date = responses.last.open_from

      # Total span should be approximately 54 months (4.5 years)
      total_days = (last_date.to_date - first_date.to_date).to_i
      expect(total_days).to be_between(1600, 1670)

      # Each consecutive pair should be approximately 6 months apart
      responses.each_cons(2) do |prev_response, next_response|
        days_between = (next_response.open_from.to_date - prev_response.open_from.to_date).to_i
        expect(days_between).to be_between(175, 190)
      end
    end
  end
end
