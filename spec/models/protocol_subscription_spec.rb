# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscription do
  it 'should have valid default properties' do
    protocol_subscription = FactoryGirl.build(:protocol_subscription)
    expect(protocol_subscription.valid?).to be_truthy
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
      protocol_subscription = FactoryGirl.create(:protocol_subscription, protocol: protocol,
                                                                         start_date: Time.new(2017, 4, 10, 0, 0, 0))
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
      protocol_subscription = FactoryGirl.create(:protocol_subscription, protocol: protocol,
                                                                         start_date: Time.new(2017, 3, 20, 0, 0, 0))
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 3, 21, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 3, 28, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 4, 4, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 4, 11, 13, 0, 0).in_time_zone)
    end
    it 'should not change the open_from time when changing from summer time to winter time', focus: true do
      # changes at 3AM Sunday, October 29 2017
      protocol = FactoryGirl.create(:protocol, duration: 4.weeks)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription, protocol: protocol,
                                                                         start_date: Time.new(2017, 10, 23, 0, 0, 0))
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 10, 24, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 10, 31, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 11, 7, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 11, 14, 13, 0, 0).in_time_zone)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription)
      expect(protocol_subscription.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol_subscription.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
