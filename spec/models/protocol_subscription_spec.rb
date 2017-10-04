# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscription do
  it 'should have valid default properties' do
    protocol_subscription = FactoryGirl.build(:protocol_subscription)
    expect(protocol_subscription.valid?).to be_truthy
  end

  context 'scopes' do
    describe 'active' do
      it 'should return protocol_subscriptions that were not completed' do
        actives = FactoryGirl.create_list(:protocol_subscription, 10, state: ProtocolSubscription::ACTIVE_STATE)
        FactoryGirl.create_list(:protocol_subscription, 15, state: ProtocolSubscription::CANCELED_STATE)
        FactoryGirl.create_list(:protocol_subscription, 20, state: ProtocolSubscription::COMPLETED_STATE)
        expect(ProtocolSubscription.active.count).to eq 10
        expect(ProtocolSubscription.active).to eq actives
      end
    end
  end

  describe 'person_id' do
    it 'should have one' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, person_id: nil)
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :person_id
      expect(protocol_subscription.errors.messages[:person_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Person' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.person).to be_a(Person)
    end
  end

  describe 'filling_out_for_id' do
    it 'should have one' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription)
      protocol_subscription.filling_out_for_id = nil
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :filling_out_for_id
      expect(protocol_subscription.errors.messages[:filling_out_for_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Person' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.filling_out_for).to be_a(Person)
    end
    it 'should set the provided person by default as a filling_out_for_person' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.filling_out_for).to eq protocol_subscription.person
    end
  end

  describe 'protocol_id' do
    it 'should have one' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, protocol_id: nil)
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :protocol_id
      expect(protocol_subscription.errors.messages[:protocol_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Protocol' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.protocol).to be_a(Protocol)
    end
  end

  describe 'state' do
    it 'should be one of the predefined states' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription.valid?).to be_truthy
      protocol_subscription = FactoryGirl.build(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription.valid?).to be_truthy
      protocol_subscription = FactoryGirl.build(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::COMPLETED_STATE
      expect(protocol_subscription.valid?).to be_truthy
    end
    it 'should not be nil' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, state: nil)
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, state: '')
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, state: 'somestring')
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'active?' do
    it 'should be active when the state is active' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, state: described_class::ACTIVE_STATE)
      expect(protocol_subscription.active?).to be_truthy
    end
    it 'should be active when the state is not active' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, state: described_class::CANCELED_STATE)
      expect(protocol_subscription.active?).to be_falsey
      protocol_subscription.state = described_class::COMPLETED_STATE
      protocol_subscription.save!
      expect(protocol_subscription.active?).to be_falsey
    end
  end

  describe 'ended?' do
    it 'should be ended after the duration of the protocol' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 5.weeks.ago.at_beginning_of_day)
      expect(protocol_subscription.ended?).to be_truthy
    end
    it 'should not be ended when the protocol_subscription is still running' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      expect(protocol_subscription.ended?).to be_falsey
    end
    it 'should not be ended when the protocol_subscription has not yet started' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 2.weeks.from_now.at_beginning_of_day)
      expect(protocol_subscription.ended?).to be_falsey
    end
  end

  describe 'start_date' do
    it 'should not be nil' do
      protocol_subscription = FactoryGirl.build(:protocol_subscription, start_date: nil)
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :start_date
      expect(protocol_subscription.errors.messages[:start_date]).to include('moet opgegeven zijn')
    end
    it 'should be the beginning of a day' do
      not_midnight = Time.new(2017, 4, 10, 12, 0, 0).in_time_zone
      protocol_subscription = FactoryGirl.build(:protocol_subscription, start_date: not_midnight)
      expect(protocol_subscription.valid?).to be_falsey
      expect(protocol_subscription.errors.messages).to have_key :start_date
      expect(protocol_subscription.errors.messages[:start_date]).to include('mag alleen middernacht zijn')
    end
  end

  describe 'for_myself?' do
    it 'should return false if it is for someone else' do
      mentor = FactoryGirl.build(:mentor)
      student = FactoryGirl.build(:student)
      protocol_subscription = FactoryGirl.build(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student)
      expect(protocol_subscription.for_myself?).to be_falsey
    end

    it 'should return true if it is for myself' do
      mentor = FactoryGirl.build(:mentor)
      protocol_subscription = FactoryGirl.build(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: mentor)
      expect(protocol_subscription.for_myself?).to be_truthy
    end
    it 'should fill out for myself by default' do
      mentor = FactoryGirl.build(:mentor)
      protocol_subscription = FactoryGirl.build(:protocol_subscription,
                                                person: mentor)
      expect(protocol_subscription.for_myself?).to be_truthy
    end
  end

  describe 'responses' do
    it 'should create responses when you create a protocol subscription' do
      protocol = FactoryGirl.create(:protocol)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription, protocol: protocol)
      expect(protocol_subscription.responses.count).to eq(3)
    end
    it 'should delete the responses when destroying the protocol subscription' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      FactoryGirl.create(:response, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.responses.first).to be_a(Response)
      responsecountbefore = Response.count
      protocol_subscription.destroy
      expect(Response.count).to eq(responsecountbefore - 1)
    end
    it 'should create responses with a nonvarying open_from' do
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 4, 11, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 4, 18, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 4, 25, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 5, 2, 13, 0, 0).in_time_zone)
    end
    it 'should not change the open_from time when changing from winter time to summer time' do
      # changes at 2AM Sunday, March 26 2017
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 3, 20, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 3, 21, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 3, 28, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 4, 4, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 4, 11, 13, 0, 0).in_time_zone)
    end
    it 'should not change the open_from time when changing from summer time to winter time' do
      # changes at 3AM Sunday, October 29 2017
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 10, 23, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 10, 24, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 10, 31, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 11, 7, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 11, 14, 13, 0, 0).in_time_zone)
    end
  end

  describe 'reward_points' do
    it 'should accumulate the reward points for all completed protocol subscriptions' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      FactoryGirl.create_list(:response, 10, :completed, protocol_subscription: protocol_subscription)
      # also add some noncompleted responses. These should not be counted.
      FactoryGirl.create_list(:response, 7, protocol_subscription: protocol_subscription)
      FactoryGirl.create_list(:response, 11, :invite_sent, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.reward_points).to eq 100
    end
  end

  describe 'possible_reward_points' do
    it 'should accumulate the reward points for all completed responses' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      FactoryGirl.create_list(:response, 10, :invite_sent, protocol_subscription: protocol_subscription)
      # also add some noninvited responses. These should not be counted.
      FactoryGirl.create_list(:response, 7, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.possible_reward_points).to eq 100
    end

    it 'should also accumulate the reward points for all not completed responses' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      FactoryGirl.create_list(:response, 10, :invite_sent, protocol_subscription: protocol_subscription)
      FactoryGirl.create_list(:response, 10, :reminder_sent, protocol_subscription: protocol_subscription)
      #
      # also add some noninvited responses. These should not be counted.
      FactoryGirl.create_list(:response, 7, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.possible_reward_points).to eq 200
    end
  end

  describe 'max_reward_points' do
    it 'should accumulate the reward points for all responses period' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      FactoryGirl.create_list(:response, 10, protocol_subscription: protocol_subscription)
      FactoryGirl.create_list(:response, 7, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.max_reward_points).to eq 170
    end
  end

  describe 'informed_consent_given_at' do
    it 'should be nil by default' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.valid?).to be_truthy
      expect(protocol_subscription.informed_consent_given_at).to be_nil
    end
    it 'should be able to be true' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, informed_consent_given_at: Time.zone.now)
      expect(protocol_subscription.valid?).to be_truthy
      expect(protocol_subscription.informed_consent_given_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol_subscription.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'protocol_completion' do
    before do
      Timecop.freeze(2017, 4, 1)
    end

    after do
      Timecop.return
    end

    it 'should calculate the correct streak' do
      protocol = FactoryGirl.create(:protocol, duration: 5.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 2, 1, 0, 0, 0).in_time_zone)
      protocol_subscription.responses.each_with_index do |response, index|
        next if index == 0 # Pretend the first response is missing
        response.completed_at = response.open_from + 1.minute
      end

      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expected = (1..protocol_subscription.responses.length - 1).to_a
      expected.unshift(0)
      expect(result).to eq expected
    end

    it 'should return -1s if there are no measurements' do
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expect(result).to eq [-1] * protocol_subscription.responses.length
    end

    it 'should return 0 if a measurement was missed' do
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 protocol: protocol,
                                                 start_date: Time.new(2017, 3, 27, 0, 0, 0).in_time_zone)
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expected = [-1] * (protocol_subscription.responses.length - 1)
      expected.unshift(0)
      expect(result).to eq expected
    end
  end
end
