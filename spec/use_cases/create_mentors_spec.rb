# frozen_string_literal: true

require 'rails_helper'

describe CreateMentors do
  let!(:protocol_for_mentors) { FactoryBot.create(:protocol, name: 'protname-mentor') }
  let!(:protocol_for_students) { FactoryBot.create(:protocol, name: 'protname-student') }
  let!(:team) { FactoryBot.create(:team, name: 'orgname') }
  let!(:role) { FactoryBot.create(:role, team: team, group: Person::MENTOR, title: 'MentorTitle') }
  let!(:plain_text_parser) { PlainTextParser.new }
  let(:dateinfuture) { 14.days.from_now.to_date.to_s }
  let(:enddateinfuture) { 42.days.from_now.to_date.to_s }
  let!(:students) { FactoryBot.create_list(:student, 20) }
  let!(:mentors) do
    [{ first_name: 'a',
       last_name: 'e',
       gender: Person::MALE,
       email: 'a@person.com',
       mobile_phone: '0612345679',
       protocol_name: protocol_for_mentors.name,
       team_name: team.name,
       role_title: role.title,
       start_date: dateinfuture,
       filling_out_for: students.first.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name,
       end_date: enddateinfuture },
     { first_name: 'b',
       last_name: 'f',
       gender: Person::FEMALE,
       email: 'b@person.com',
       mobile_phone: '06-12345670',
       protocol_name: protocol_for_mentors.name,
       team_name: team.name,
       role_title: role.title,
       start_date: dateinfuture,
       filling_out_for: students.second.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name,
       end_date: enddateinfuture },
     { first_name: 'c',
       last_name: 'g',
       gender: Person::FEMALE,
       email: 'c@person.com',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       team_name: team.name,
       role_title: role.title,
       start_date: dateinfuture,
       filling_out_for: students.third.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name,
       end_date: enddateinfuture },
     { first_name: 'c',
       last_name: 'g',
       gender: Person::FEMALE,
       email: 'c@person.com',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       team_name: team.name,
       role_title: role.title,
       start_date: dateinfuture,
       filling_out_for: students.fourth.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name,
       end_date: enddateinfuture },
     { first_name: 'c',
       last_name: 'g',
       gender: Person::FEMALE,
       email: 'c@person.com',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       team_name: team.name,
       role_title: role.title,
       start_date: dateinfuture,
       filling_out_for: students.fifth.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name,
       end_date: enddateinfuture }]
  end

  describe 'execute' do
    it 'accepts an array as arguments' do
      expect do
        described_class.run!(mentors: [])
      end.not_to raise_error
    end
  end

  describe 'parse_mentors' do
    it 'returns an array with all mentors' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      expect(result).to be_a(Array)
      expect(result.length).to eq mentors.length
    end

    it 'sets the correct keys' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      expect(result.map(&:keys).uniq.flatten).to match_array(%i[first_name
                                                                last_name
                                                                gender
                                                                email
                                                                mobile_phone
                                                                protocol_id
                                                                start_date
                                                                filling_out_for_id
                                                                filling_out_for_protocol_id
                                                                role_id
                                                                end_date])
    end

    it 'sets the correct data' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      timedateinfuture = Time.zone.parse(dateinfuture)
      endtimedateinfuture = Time.zone.parse(enddateinfuture)
      expect(result.first).to eq(first_name: 'a',
                                 last_name: 'e',
                                 gender: Person::MALE,
                                 email: 'a@person.com',
                                 mobile_phone: '0612345679',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.first.id,
                                 filling_out_for_protocol_id: protocol_for_students.id,
                                 role_id: role.id,
                                 end_date: endtimedateinfuture)
      expect(result.second).to eq(first_name: 'b',
                                  last_name: 'f',
                                  gender: Person::FEMALE,
                                  email: 'b@person.com',
                                  mobile_phone: '0612345670',
                                  protocol_id: protocol_for_mentors.id,
                                  start_date: timedateinfuture,
                                  filling_out_for_id: students.second.id,
                                  filling_out_for_protocol_id: protocol_for_students.id,
                                  role_id: role.id,
                                  end_date: endtimedateinfuture)
      expect(result.third).to eq(first_name: 'c',
                                 last_name: 'g',
                                 gender: Person::FEMALE,
                                 email: 'c@person.com',
                                 mobile_phone: '0612345671',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.third.id,
                                 filling_out_for_protocol_id: protocol_for_students.id,
                                 role_id: role.id,
                                 end_date: endtimedateinfuture)
      expect(result.fourth).to eq(first_name: 'c',
                                  last_name: 'g',
                                  gender: Person::FEMALE,
                                  email: 'c@person.com',
                                  mobile_phone: '0612345671',
                                  protocol_id: protocol_for_mentors.id,
                                  start_date: timedateinfuture,
                                  filling_out_for_id: students.fourth.id,
                                  filling_out_for_protocol_id: protocol_for_students.id,
                                  role_id: role.id,
                                  end_date: endtimedateinfuture)
      expect(result.fifth).to eq(first_name: 'c',
                                 last_name: 'g',
                                 gender: Person::FEMALE,
                                 email: 'c@person.com',
                                 mobile_phone: '0612345671',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.fifth.id,
                                 filling_out_for_protocol_id: protocol_for_students.id,
                                 role_id: role.id,
                                 end_date: endtimedateinfuture)
    end
  end

  describe 'create_mentors' do
    let(:timedateinfuture) { Time.zone.parse(dateinfuture) }
    let(:endtimedateinfuture) { Time.zone.parse(enddateinfuture) }
    let(:parsed_mentors) do
      [
        { first_name: 'a',
          last_name: 'e',
          mobile_phone: '0612345679',
          gender: Person::MALE,
          email: 'a@person.com',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.first.id,
          filling_out_for_protocol_id: protocol_for_students.id,
          role_id: role.id,
          end_date: endtimedateinfuture },
        { first_name: 'b',
          last_name: 'f',
          gender: nil,
          email: 'b@person.com',
          mobile_phone: '0612345670',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.second.id,
          filling_out_for_protocol_id: protocol_for_students.id,
          role_id: role.id,
          end_date: endtimedateinfuture },
        # Note that the next 3 mentors have the same phone number
        { first_name: 'c',
          last_name: 'g',
          gender: Person::FEMALE,
          email: 'c@person.com',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.third.id,
          filling_out_for_protocol_id: protocol_for_students.id,
          role_id: role.id,
          end_date: endtimedateinfuture },
        { first_name: 'c',
          last_name: 'g',
          gender: Person::FEMALE,
          email: 'c@person.com',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.fourth.id,
          filling_out_for_protocol_id: protocol_for_students.id,
          role_id: role.id,
          end_date: endtimedateinfuture },
        { first_name: 'c',
          last_name: 'g',
          gender: Person::FEMALE,
          email: 'c@person.com',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.fifth.id,
          filling_out_for_protocol_id: protocol_for_students.id,
          role_id: role.id,
          end_date: endtimedateinfuture }
      ]
    end

    it 'creates mentors for all hashes in the array supplied' do
      mentor_pre = Person.count
      subject.send(:create_mentors, parsed_mentors)
      expect(Person.count).to eq parsed_mentors.pluck(:mobile_phone).uniq.count + mentor_pre
    end

    it 'creates the correct mentors' do
      subject.send(:create_mentors, parsed_mentors)
      parsed_mentors.each do |hash|
        act = Person.find_by(mobile_phone: hash[:mobile_phone])
        expect(act.first_name).to eq hash[:first_name]
        expect(act.last_name).to eq hash[:last_name]
        expect(act.email).to eq hash[:email]
        expect(act.gender).to eq hash[:gender]
        expect(act.mobile_phone).to eq hash[:mobile_phone]
        expect(act.role.id).to eq role.id
      end
    end

    it 'assigns the correct protocol subscriptions to a mentor' do
      subject.send(:create_mentors, parsed_mentors)
      (0..1).each do |idx|
        hash = parsed_mentors[idx]
        act = Person.find_by(mobile_phone: hash[:mobile_phone])
        expect(act.protocol_subscriptions.count).to eq 2
        expect(act.protocol_subscriptions.first.protocol.id).to eq protocol_for_students.id
        expect(act.protocol_subscriptions.first.start_date).to be_within(1.minute).of(timedateinfuture)
        expect(act.protocol_subscriptions.first.end_date).to be_within(1.minute).of(endtimedateinfuture)
        expect(act.protocol_subscriptions.first.filling_out_for_id).to eq students[idx].id
        expect(act.protocol_subscriptions.second.protocol.id).to eq protocol_for_mentors.id
        expect(act.protocol_subscriptions.second.start_date).to be_within(1.minute).of(timedateinfuture)
        expect(act.protocol_subscriptions.second.end_date).to be_within(1.minute).of(endtimedateinfuture)
        expect(act.protocol_subscriptions.second.filling_out_for_id).to eq act.id
      end

      hash = parsed_mentors.third
      act = Person.find_by(mobile_phone: hash[:mobile_phone])
      expect(act.protocol_subscriptions.count).to eq 4
      expect(act.protocol_subscriptions.first.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.first.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.first.end_date).to be_within(1.minute).of(endtimedateinfuture)
      expect(act.protocol_subscriptions.first.filling_out_for_id).to eq students.fifth.id

      expect(act.protocol_subscriptions.second.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.second.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.second.end_date).to be_within(1.minute).of(endtimedateinfuture)
      expect(act.protocol_subscriptions.second.filling_out_for_id).to eq students.fourth.id

      expect(act.protocol_subscriptions.third.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.third.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.third.end_date).to be_within(1.minute).of(endtimedateinfuture)
      expect(act.protocol_subscriptions.third.filling_out_for_id).to eq students.third.id

      expect(act.protocol_subscriptions.fourth.protocol.id).to eq protocol_for_mentors.id
      expect(act.protocol_subscriptions.fourth.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.fourth.end_date).to be_within(1.minute).of(endtimedateinfuture)
      expect(act.protocol_subscriptions.fourth.filling_out_for_id).to eq act.id
    end
  end
end
