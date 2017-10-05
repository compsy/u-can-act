# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a person object' do
  describe 'inheritance' do
    it 'should be a Person' do
      expect(subject).to be_a Person
    end
  end

  it 'should have valid default properties' do
    person = FactoryGirl.build(:person)
    expect(person.valid?).to be_truthy
  end

  describe 'mobile_phone' do
    let(:person) { FactoryGirl.create(:person) }

    it 'should not accept an empty number' do
      person.mobile_phone = ''
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te kort (minimaal 10 tekens)')
    end

    it 'should not accept nil as a number' do
      person.mobile_phone = nil
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is ongeldig')
    end

    it 'should not accept numbers that are not length 10' do
      person.mobile_phone = '061234567'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te kort (minimaal 10 tekens)')
      person.mobile_phone = '06123456789'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te lang (maximaal 10 tekens)')
    end

    it 'should not accept numbers that do not start with 06' do
      person.mobile_phone = '0112345678'
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('mag alleen een Nederlands nummer zijn')
    end

    it 'should have a uniqueness constraint on phone numbers' do
      student = FactoryGirl.create(:student, mobile_phone: '0611111111')
      expect(student.valid?).to be_truthy
      mentor = FactoryGirl.build(:mentor, mobile_phone: '0611111111')
      expect(mentor.valid?).to be_falsey
      expect(mentor.errors.messages).to have_key :mobile_phone
      expect(mentor.errors.messages[:mobile_phone]).to include('is al in gebruik')
    end
  end

  describe 'organization_id', focus: true do
    it 'should have one' do
      person = FactoryGirl.build(:person, organization_id: nil)
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :organization_id
      expect(person.errors.messages[:organization_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve an Organization' do
      person = FactoryGirl.create(:person)
      expect(person.organization).to be_a(Organization)
    end
  end

  describe 'gender', focus: true do
    it 'should be one of the predefined genders' do
      person = FactoryGirl.build(:person)
      person.gender = Person::MALE
      expect(person.valid?).to be_truthy
      person = FactoryGirl.build(:person)
      person.gender = Person::FEMALE
      expect(person.valid?).to be_truthy
    end
    it 'should accept nil' do
      person = FactoryGirl.build(:person, gender: nil)
      expect(person.valid?).to be_truthy
    end
    it 'should not be empty' do
      person = FactoryGirl.build(:person, gender: '')
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      person = FactoryGirl.build(:person, gender: 'somestring')
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'first_name' do
    let(:person) { FactoryGirl.create(:person) }

    it 'should not accept an empty first_name' do
      person.first_name = ''
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :first_name
      expect(person.errors.messages[:first_name]).to include('moet opgegeven zijn')
    end

    it 'should not accept nil as a first_name' do
      person.first_name = nil
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :first_name
      expect(person.errors.messages[:first_name]).to include('moet opgegeven zijn')
    end
  end

  describe 'protocol_subscriptions' do
    it 'should destroy the protocol_subscriptions when destroying the person' do
      person = FactoryGirl.create(:person, :with_protocol_subscriptions)
      expect(person.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      person.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'reward_points' do
    it 'should accumulate the reward points for all completed protocol subscriptions' do
      person = FactoryGirl.create(:person, :with_protocol_subscriptions)
      FactoryGirl.create(:protocol_subscription, person: person)
      FactoryGirl.create_list(:response, 10, :completed, protocol_subscription: person.protocol_subscriptions.first)
      FactoryGirl.create_list(:response, 5, :completed, protocol_subscription: person.protocol_subscriptions.second)
      # also add some noncompleted responses. These should not be counted.
      FactoryGirl.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      FactoryGirl.create_list(:response, 11, :invite_sent, protocol_subscription: person.protocol_subscriptions.first)
      expect(person.reward_points).to eq 150
    end
  end

  describe 'possible_reward_points' do
    it 'should accumulate the reward points for all completed responses' do
      person = FactoryGirl.create(:person, :with_protocol_subscriptions)
      FactoryGirl.create(:protocol_subscription, person: person)
      FactoryGirl.create_list(:response, 10, :invite_sent, protocol_subscription: person.protocol_subscriptions.first)
      FactoryGirl.create_list(:response, 5, :invite_sent, protocol_subscription: person.protocol_subscriptions.second)
      # also add some noninvited responses. These should not be counted.
      FactoryGirl.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      expect(person.possible_reward_points).to eq 150
    end
  end

  describe 'max_reward_points' do
    it 'should accumulate the reward points for all responses period' do
      person = FactoryGirl.create(:person, :with_protocol_subscriptions)
      FactoryGirl.create(:protocol_subscription, person: person)
      FactoryGirl.create_list(:response, 10, protocol_subscription: person.protocol_subscriptions.first)
      FactoryGirl.create_list(:response, 5, protocol_subscription: person.protocol_subscriptions.second)
      FactoryGirl.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      expect(person.max_reward_points).to eq 220
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      person = FactoryGirl.create(:person)
      expect(person.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(person.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
