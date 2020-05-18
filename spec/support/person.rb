# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'a person object' do
  describe 'inheritance' do
    it 'is a Person' do
      expect(subject).to be_a Person
    end
  end

  it 'has valid default properties' do
    person = FactoryBot.create(:person)
    expect(person).to be_valid
  end

  describe 'my_students' do
    it 'returns an empty array if the person is not a mentor' do
      student = FactoryBot.create(:student)
      result = student.my_students
      expect(result).to be_blank
      expect(result).to eq []
    end

    it 'returns a list of all students supervised by a mentor' do
      mentor = FactoryBot.create(:mentor)
      students = FactoryBot.create_list(:student, 10)
      students.each do |student|
        FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      end
      result = mentor.my_students

      expect(result).not_to be_blank
      expect(result).to match_array students
    end

    it 'also iterates over inactive protocol subscriptions' do
      mentor = FactoryBot.create(:mentor)
      students = FactoryBot.create_list(:student, 10)
      students.each do |student|
        FactoryBot.create(:protocol_subscription, :canceled, person: mentor, filling_out_for: student)
      end
      result = mentor.my_students

      expect(result).not_to be_blank
      expect(result).to match_array students
    end
  end

  describe 'parent and children' do
    it 'retrieves another person' do
      parent = FactoryBot.create(:person)
      child = FactoryBot.create(:person, parent: parent)
      parent.reload
      expect(child.parent).to eq parent
      expect(parent.children).to eq [child]
    end

    it 'nullifies the parent_id but not destroy the children when destroying parent' do
      parent = FactoryBot.create(:person)
      child = FactoryBot.create(:person, parent: parent)
      parent.reload
      expect(child.parent_id).not_to be_blank
      expect { parent.destroy }.to change(Person, :count).by(-1)
      child.reload
      expect(child.parent).to be_blank
      expect(child.parent_id).to be_blank
    end

    it 'is not possible to set yourself as your own parent or child' do
      parent = FactoryBot.create(:person)
      parent.parent = parent
      expected_error = { parent: ['cannot be parent of yourself'] }
      expect(parent).not_to be_valid
      expect(parent.errors).not_to be_blank
      expect(parent.errors.messages).to eq expected_error
    end
  end

  describe 'iban' do
    let(:person) { FactoryBot.create(:person) }

    it 'has a validated iban' do
      person.iban = '123'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :iban
      expect(person.errors.messages[:iban]).to include('is ongeldig')
    end

    it 'calls the iban validator' do
      expect_any_instance_of(IbanValidator).to receive(:validate).with(person).and_call_original
      person.iban = '123'
      expect(person).not_to be_valid
    end
  end

  describe 'mobile_phone' do
    let(:person) { FactoryBot.create(:person) }

    it 'calls the mobile phone validator' do
      expect_any_instance_of(MobilePhoneValidator).to receive(:validate).with(person).and_call_original
      person.mobile_phone = '123'
      expect(person).not_to be_valid
    end

    it 'accepts an empty number' do
      person.mobile_phone = ''
      expect(person).to be_valid
    end

    it 'accepts nil as a number' do
      person.mobile_phone = nil
      expect(person).to be_valid
    end

    it 'does not accept numbers that are not length 10' do
      person.mobile_phone = '061234567'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te kort (minimaal 10 tekens)')
      person.mobile_phone = '06123456789'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('is te lang (maximaal 10 tekens)')
    end

    it 'does not accept numbers that do not start with 06' do
      person.mobile_phone = '0112345678'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :mobile_phone
      expect(person.errors.messages[:mobile_phone]).to include('mag alleen een Nederlands nummer zijn')
    end

    it 'has a uniqueness constraint on phone numbers' do
      student = FactoryBot.create(:student, mobile_phone: '0611111111')
      expect(student).to be_valid
      mentor = FactoryBot.create(:mentor)
      mentor.mobile_phone = '0611111111'
      expect(mentor).not_to be_valid
      expect(mentor.errors.messages).to have_key :mobile_phone
      expect(mentor.errors.messages[:mobile_phone]).to include('is al in gebruik')
    end
  end

  describe 'email' do
    it 'accepts a nil email' do
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
      expect { FactoryBot.create(:person, email: '') }.to raise_error(ActiveRecord::RecordNotUnique)
      expect(Person.count).to eq(3)
    end

    it 'does not accept a double period' do
      person = FactoryBot.create(:person)
      person.email = 'mentor..hoi@test.com'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :email
      expect(person.errors.messages[:email]).to include('is ongeldig')
    end

    it 'does not accept general invalid emails' do
      invalid_emails = %w[mentor..hoi@test.com mentor-hoi@ @test.com]
      invalid_emails.each do |email|
        person = FactoryBot.create(:person)
        person.email = email
        expect(person).not_to be_valid
        expect(person.errors.messages).to have_key :email
        expect(person.errors.messages[:email]).to include('is ongeldig')
      end
    end

    it 'accepts general valid emails' do
      valid_emails = %w[mentor.hoi@test.com mentor-hoi@test.com b@a.com mentor+test@test.com]
      valid_emails.each do |email|
        person = FactoryBot.create(:person, email: email)
        expect(person).to be_valid
      end
    end
  end

  describe 'role_id' do
    it 'has one' do
      person = FactoryBot.create(:person)
      person.role_id = nil
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :role_id
      expect(person.errors.messages[:role_id]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve an role' do
      person = FactoryBot.create(:person)
      expect(person.role).to be_a(Role)
    end
  end

  describe 'gender' do
    it 'is one of the predefined genders' do
      person = FactoryBot.create(:person)
      person.gender = Person::MALE
      expect(person).to be_valid
      person = FactoryBot.create(:person)
      person.gender = Person::FEMALE
      expect(person).to be_valid
    end
    it 'accepts nil' do
      person = FactoryBot.create(:person, gender: nil)
      expect(person).to be_valid
    end
    it 'is not empty' do
      person = FactoryBot.create(:person)
      person.gender = ''
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      person = FactoryBot.create(:person)
      person.gender = 'somestring'
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :gender
      expect(person.errors.messages[:gender]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'first_name' do
    let(:person) { FactoryBot.create(:person) }

    it 'does not accept an empty first_name' do
      person.first_name = ''
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :first_name
      expect(person.errors.messages[:first_name]).to include('moet opgegeven zijn')
    end

    it 'does not accept nil as a first_name' do
      person.first_name = nil
      expect(person).not_to be_valid
      expect(person.errors.messages).to have_key :first_name
      expect(person.errors.messages[:first_name]).to include('moet opgegeven zijn')
    end
  end

  describe 'protocol_subscriptions' do
    it 'destroys the protocol_subscriptions when destroying the person' do
      person = FactoryBot.create(:person, :with_protocol_subscriptions)
      expect(person.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      person.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'responses' do
    it 'counts all responses for a person' do
      person = FactoryBot.create(:person)
      protsub1 = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create_list(:response, 10, :completed, protocol_subscription: protsub1)
      FactoryBot.create_list(:response, 7, protocol_subscription: protsub1)
      protsub2 = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create_list(:response, 5, :completed, protocol_subscription: protsub2)
      FactoryBot.create_list(:response, 3, protocol_subscription: protsub2)
      expect(person.responses.count).to eq 25
      expect(person.responses.completed.count).to eq 15
    end
  end

  describe 'my_open_responses' do
    it 'counts all responses for a person' do
      person = FactoryBot.create(:person)
      protsub1 = FactoryBot.create(:protocol_subscription, person: person, start_date: Time.zone.now.beginning_of_day)
      resp1 = FactoryBot.create(:response, open_from: 60.minutes.ago, protocol_subscription: protsub1)
      FactoryBot.create(:response, :completed, open_from: 61.minutes.ago, protocol_subscription: protsub1)
      resp3 = FactoryBot.create(:response, open_from: 70.minutes.ago, protocol_subscription: protsub1)
      protsub2 = FactoryBot.create(:protocol_subscription, person: person, start_date: 1.day.ago.beginning_of_day)
      resp2 = FactoryBot.create(:response, open_from: 65.minutes.ago, protocol_subscription: protsub2)
      FactoryBot.create(:response, :completed, open_from: 71.minutes.ago, protocol_subscription: protsub2)
      resp4 = FactoryBot.create(:response, open_from: 75.minutes.ago, protocol_subscription: protsub2)
      expect(person.my_open_responses).to eq [resp4, resp3, resp2, resp1]
    end
  end

  describe 'invitation_sets' do
    it 'destroys the invitation_sets when destroying the person' do
      person = FactoryBot.create(:person)
      FactoryBot.create(:invitation_set, person: person)
      expect(person.invitation_sets.first).to be_an(InvitationSet)
      invsetbefore = InvitationSet.count
      person.destroy
      expect(InvitationSet.count).to eq(invsetbefore - 1)
    end
  end

  describe 'mentor?' do
    it 'is true when the current person is a mentor' do
      person = FactoryBot.create(:mentor)
      expect(person).to be_mentor
    end

    it 'is false when the current person is not a mentor' do
      person = FactoryBot.create(:student)
      expect(person).not_to be_mentor
    end
  end

  describe 'solo?' do
    it 'is true when the current person is a solo' do
      person = FactoryBot.create(:solo)
      expect(person).to be_solo
      expect(person).not_to be_mentor
    end

    it 'is false when the current person is not a solo' do
      person = FactoryBot.create(:student)
      expect(person).not_to be_solo
      person = FactoryBot.create(:mentor)
      expect(person).not_to be_solo
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      person = FactoryBot.create(:person)
      expect(person.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(person.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'destroy' do
    it 'destroys a person even though other people are filling out for it' do
      person = FactoryBot.create(:person)
      response = FactoryBot.create(:response)
      response.filled_out_for = person
      response.save!
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      other_person_id = protocol_subscription.person.id
      protocol_subscription.filling_out_for = person
      protocol_subscription.save!
      expect(person.responses_filled_out_for_me).to eq([response])
      expect { person.destroy }.to change(Person, :count).by(-1)
      response.reload
      expect(response.filled_out_for_id).to be_blank
      protocol_subscription.reload
      expect(protocol_subscription.filling_out_for_id).to eq(other_person_id)
    end
  end

  describe 'external_identifier' do
    it 'validates the alpha numeric of size IDENTIFIER_LENGTH format' do
      person = FactoryBot.create(:person)
      test_string = SecureRandom.hex(32)
      #
      # Too short
      (0..(described_class::IDENTIFIER_LENGTH - 1)).each do |chars|
        ext_ident = test_string[0...chars]
        person.external_identifier = ext_ident
        expect(person).not_to be_valid
      end

      # Too long
      ((described_class::IDENTIFIER_LENGTH + 1)..(described_class::IDENTIFIER_LENGTH * 2)).each do |chars|
        ext_ident = test_string[0..chars]
        person.external_identifier = ext_ident
        expect(person).not_to be_valid
      end

      # Goldilocks zone
      ext_ident = test_string[0...described_class::IDENTIFIER_LENGTH]
      person.external_identifier = ext_ident
      expect(person).to be_valid
    end

    it 'does not allow empty external identifiers' do
      person = FactoryBot.create(:person)
      person.external_identifier = nil
      expect(person).not_to be_valid

      person.external_identifier = ''
      expect(person).not_to be_valid
    end

    it 'creates an external_identifier on initialization' do
      person = FactoryBot.create(:person)
      expect(person.external_identifier).not_to be_blank
      expect(person.external_identifier.length).to eq described_class::IDENTIFIER_LENGTH
    end

    it 'does not allow non-unique identifiers' do
      person = FactoryBot.create(:person)
      person2 = FactoryBot.create(:person)
      person2.external_identifier = person.external_identifier
      expect(person2).not_to be_valid
      expect(person2.errors.messages).to have_key :external_identifier
      expect(person2.errors.messages[:external_identifier]).to include('is al in gebruik')
    end
  end

  describe 'Student' do
    it 'has working factory defaults' do
      pcountb = Person.count
      student = FactoryBot.create(:student)
      expect(student).to be_valid
      expect(student.role.group).to eq Person::STUDENT
      expect(Person.count).to eq(pcountb + 1)
    end
  end

  describe 'Mentor' do
    it 'has working factory defaults' do
      pcountb = Person.count
      mentor = FactoryBot.create(:mentor)
      expect(mentor).to be_valid
      expect(mentor.role.group).to eq Person::MENTOR
      expect(Person.count).to eq(pcountb + 1)
    end
  end
end
