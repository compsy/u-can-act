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
    xit 'should create responses when you create a protocol subscription' do
      protocol = FactoryGirl.create(:protocol)
      FactoryGirl.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription, protocol: protocol)
      expect(protocol_subscription.responses.count).to eq(3)
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
