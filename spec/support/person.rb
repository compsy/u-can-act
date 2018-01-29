# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a person object' do
  describe 'inheritance' do
    it 'should be a Person' do
      expect(subject).to be_a Person
    end
  end

  it 'should have valid default properties' do
    person = FactoryBot.build(:person)
    expect(person.valid?).to be_truthy
  end

  describe 'mobile_phone' do
    let(:person) { FactoryBot.create(:person) }

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
      student = FactoryBot.create(:student, mobile_phone: '0611111111')
      expect(student.valid?).to be_truthy
      mentor = FactoryBot.build(:mentor, mobile_phone: '0611111111')
      expect(mentor.valid?).to be_falsey
      expect(mentor.errors.messages).to have_key :mobile_phone
      expect(mentor.errors.messages[:mobile_phone]).to include('is al in gebruik')
    end
  end

  describe 'email' do
    it 'should accept a nil email' do
      person = FactoryBot.create(:person, email: nil)
      expect(person).to be_valid
      person = FactoryBot.create(:person, email: '')
      expect(person).to be_valid
    end

    it 'two nil emails should still be unique' do
      expect(Person.count).to eq(0)
      FactoryBot.create(:person, email: nil)
      FactoryBot.create(:person, email: '')
      FactoryBot.create(:person, email: nil)
      FactoryBot.create(:person, email: '')
      expect(Person.count).to eq(4)
    end

    it 'should not accept a double period' do
      person = FactoryBot.build(:person, email: 'mentor..hoi@test.com')
      expect(person).to_not be_valid
      expect(person.errors.messages).to have_key :email
      expect(person.errors.messages[:email]).to include('is ongeldig')
    end

    it 'should not accept general invalid emails' do
      invalid_emails = %w[mentor..hoi@test.com mentor-hoi@ @test.com]
      invalid_emails.each do |email|
        person = FactoryBot.build(:person, email: email)
        expect(person).to_not be_valid
        expect(person.errors.messages).to have_key :email
        expect(person.errors.messages[:email]).to include('is ongeldig')
      end
    end

    it 'should accept general valid emails' do
      valid_emails = %w[mentor.hoi@test.com mentor-hoi@test.com b@a.com mentor+test@test.com]
      valid_emails.each do |email|
        person = FactoryBot.build(:person, email: email)
        expect(person).to be_valid
      end
    end
  end

  describe 'role_id' do
    it 'should have one' do
      person = FactoryBot.build(:person, role_id: nil)
      expect(person).to_not be_valid
      expect(person.errors.messages).to have_key :role_id
      expect(person.errors.messages[:role_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve an role' do
      person = FactoryBot.create(:person)
      expect(person.role).to be_a(Role)
    end
  end

  describe 'gender' do
    it 'should be one of the predefined genders' do
      person = FactoryBot.build(:person)
      person.gender = Person::MALE
      expect(person.valid?).to be_truthy
      person = FactoryBot.build(:person)
      person.gender = Person::FEMALE
      expect(person.valid?).to be_truthy
    end
    it 'should accept nil' do
      person = FactoryBot.build(:person, gender: nil)
      expect(person.valid?).to be_truthy
    end
    it 'should not be empty' do
      person = FactoryBot.build(:person, gender: '')
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      person = FactoryBot.build(:person, gender: 'somestring')
      expect(person.valid?).to be_falsey
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'first_name' do
    let(:person) { FactoryBot.create(:person) }

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
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      expect(person.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      person.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'mentor?' do
    it 'should be true when the current person is a mentor' do
      person = FactoryBot.create(:mentor)
      expect(person.mentor?).to be_truthy
    end

    it 'should be false when the current person is not a mentor' do
      person = FactoryBot.create(:student)
      expect(person.mentor?).to be_falsey
    end
  end

  describe 'reward_points' do
    it 'should accumulate the reward points for all completed protocol subscriptions' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create_list(:response, 10, :completed, protocol_subscription: person.protocol_subscriptions.first)
      FactoryBot.create_list(:response, 5, :completed, protocol_subscription: person.protocol_subscriptions.second)
      # also add some noncompleted responses. These should not be counted.
      FactoryBot.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      FactoryBot.create_list(:response, 11, :invite_sent, protocol_subscription: person.protocol_subscriptions.first)
      expect(person.reward_points).to eq 15
    end
  end

  describe 'possible_reward_points' do
    it 'should accumulate the reward points for all completed responses' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create_list(:response, 10, :invite_sent, protocol_subscription: person.protocol_subscriptions.first)
      FactoryBot.create_list(:response, 5, :invite_sent, protocol_subscription: person.protocol_subscriptions.second)
      # also add some noninvited responses. These should not be counted.
      FactoryBot.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      expect(person.possible_reward_points).to eq 15
    end
  end

  describe 'max_reward_points' do
    it 'should accumulate the reward points for all responses period' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create_list(:response, 10, protocol_subscription: person.protocol_subscriptions.first)
      FactoryBot.create_list(:response, 5, protocol_subscription: person.protocol_subscriptions.second)
      FactoryBot.create_list(:response, 7, protocol_subscription: person.protocol_subscriptions.second)
      expect(person.max_reward_points).to eq 22
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      person = FactoryBot.create(:person)
      expect(person.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(person.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'Student' do
    it 'should have working factory defaults' do
      student = FactoryBot.build(:student)
      pcountb = Person.count
      expect(student.valid?).to be_truthy
      expect(student.role.group).to eq Person::STUDENT
      student.save
      expect(Person.count).to eq(pcountb + 1)
    end
  end

  describe 'Mentor' do
    it 'should have working factory defaults' do
      mentor = FactoryBot.build(:mentor)
      pcountb = Person.count
      expect(mentor.valid?).to be_truthy
      expect(mentor.role.group).to eq Person::MENTOR
      mentor.save
      expect(Person.count).to eq(pcountb + 1)
    end
  end
end
