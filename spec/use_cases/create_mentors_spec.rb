
# frozen_string_literal: true

require 'rails_helper'

describe CreateMentors do
  let!(:protocol_for_mentors) { FactoryGirl.create(:protocol, name: 'protname-mentor') }
  let!(:protocol_for_students) { FactoryGirl.create(:protocol, name: 'protname-student') }
  let!(:plain_text_parser) { PlainTextParser.new }
  let(:dateinfuture) { 14.days.from_now.to_date.to_s }
  let!(:students) { FactoryGirl.create_list(:student, 20) }
  let!(:mentors) do
    [{ first_name: 'a',
       last_name: 'e',
       mobile_phone: '0612345679',
       protocol_name: protocol_for_mentors.name,
       start_date: dateinfuture,
       filling_out_for: students.first.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name },
     { first_name: 'b',
       last_name: 'f',
       mobile_phone: '06-12345670',
       protocol_name: protocol_for_mentors.name,
       start_date: dateinfuture,
       filling_out_for: students.second.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name },
     { first_name: 'c',
       last_name: 'g',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       start_date: dateinfuture,
       filling_out_for: students.third.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name },
     { first_name: 'c',
       last_name: 'g',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       start_date: dateinfuture,
       filling_out_for: students.fourth.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name },
     { first_name: 'c',
       last_name: 'g',
       mobile_phone: '0612345671',
       protocol_name: protocol_for_mentors.name,
       start_date: dateinfuture,
       filling_out_for: students.fifth.mobile_phone,
       filling_out_for_protocol: protocol_for_students.name }]
  end

  describe 'execute' do
    it 'should accept an array as arguments' do
      expect do
        described_class.run!(mentors: [])
      end.to_not raise_error
    end
  end

  describe 'parse_mentors' do
    it 'should return an array with all mentors' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      expect(result).to be_a(Array)
      expect(result.length).to eq mentors.length
    end

    it 'should set the correct keys' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      expect(result.map(&:keys).uniq.flatten).to match_array(%i[first_name
                                                                last_name
                                                                mobile_phone
                                                                protocol_id
                                                                start_date
                                                                filling_out_for_id
                                                                filling_out_for_protocol_id])
    end

    it 'should set the correct data' do
      result = subject.send(:parse_mentors, mentors, plain_text_parser)
      timedateinfuture = Time.zone.parse(dateinfuture)
      expect(result.first).to eq(first_name: 'a',
                                 last_name: 'e',
                                 mobile_phone: '0612345679',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.first.id,
                                 filling_out_for_protocol_id: protocol_for_students.id)
      expect(result.second).to eq(first_name: 'b',
                                  last_name: 'f',
                                  mobile_phone: '0612345670',
                                  protocol_id: protocol_for_mentors.id,
                                  start_date: timedateinfuture,
                                  filling_out_for_id: students.second.id,
                                  filling_out_for_protocol_id: protocol_for_students.id)
      expect(result.third).to eq(first_name: 'c',
                                 last_name: 'g',
                                 mobile_phone: '0612345671',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.third.id,
                                 filling_out_for_protocol_id: protocol_for_students.id)
      expect(result.fourth).to eq(first_name: 'c',
                                  last_name: 'g',
                                  mobile_phone: '0612345671',
                                  protocol_id: protocol_for_mentors.id,
                                  start_date: timedateinfuture,
                                  filling_out_for_id: students.fourth.id,
                                  filling_out_for_protocol_id: protocol_for_students.id)
      expect(result.fifth).to eq(first_name: 'c',
                                 last_name: 'g',
                                 mobile_phone: '0612345671',
                                 protocol_id: protocol_for_mentors.id,
                                 start_date: timedateinfuture,
                                 filling_out_for_id: students.fifth.id,
                                 filling_out_for_protocol_id: protocol_for_students.id)
    end
  end

  describe 'create_mentors' do
    let(:timedateinfuture) { Time.zone.parse(dateinfuture) }
    let(:parsed_mentors) do
      [
        { first_name: 'a',
          last_name: 'e',
          mobile_phone: '0612345679',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.first.id,
          filling_out_for_protocol_id: protocol_for_students.id },
        { first_name: 'b',
          last_name: 'f',
          mobile_phone: '0612345670',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.second.id,
          filling_out_for_protocol_id: protocol_for_students.id },
        { first_name: 'c',
          last_name: 'g',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.third.id,
          filling_out_for_protocol_id: protocol_for_students.id },
        { first_name: 'c',
          last_name: 'g',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.fourth.id,
          filling_out_for_protocol_id: protocol_for_students.id },
        { first_name: 'c',
          last_name: 'g',
          mobile_phone: '0612345671',
          protocol_id: protocol_for_mentors.id,
          start_date: timedateinfuture,
          filling_out_for_id: students.fifth.id,
          filling_out_for_protocol_id: protocol_for_students.id }
      ]
    end

    it 'should create mentors for all hashes in the array supplied' do
      expect(Mentor.count).to eq 0
      subject.send(:create_mentors, parsed_mentors)
      expect(Mentor.count).to eq parsed_mentors.map { |x| x[:mobile_phone] }.uniq.count
    end

    it 'should create the correct mentors' do
      subject.send(:create_mentors, parsed_mentors)
      parsed_mentors.each do |hash|
        act = Mentor.find_by_mobile_phone(hash[:mobile_phone])
        expect(act.first_name).to eq hash[:first_name]
        expect(act.last_name).to eq hash[:last_name]
        expect(act.mobile_phone).to eq hash[:mobile_phone]
      end
    end

    it 'should assign the correct protocol subscriptions to a mentor' do
      subject.send(:create_mentors, parsed_mentors)
      (0..1).each do |idx|
        hash = parsed_mentors[idx]
        act = Mentor.find_by_mobile_phone(hash[:mobile_phone])
        expect(act.protocol_subscriptions.count).to eq 2
        expect(act.protocol_subscriptions.first.protocol.id).to eq protocol_for_students.id
        expect(act.protocol_subscriptions.first.start_date).to be_within(1.minute).of(timedateinfuture)
        expect(act.protocol_subscriptions.first.filling_out_for_id).to eq students[idx].id
        expect(act.protocol_subscriptions.second.protocol.id).to eq protocol_for_mentors.id
        expect(act.protocol_subscriptions.second.start_date).to be_within(1.minute).of(timedateinfuture)
        expect(act.protocol_subscriptions.second.filling_out_for_id).to eq act.id
      end

      hash = parsed_mentors.third
      act = Mentor.find_by_mobile_phone(hash[:mobile_phone])
      expect(act.protocol_subscriptions.count).to eq 4
      expect(act.protocol_subscriptions.first.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.first.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.first.filling_out_for_id).to eq students.fifth.id

      expect(act.protocol_subscriptions.second.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.second.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.second.filling_out_for_id).to eq students.fourth.id

      expect(act.protocol_subscriptions.third.protocol.id).to eq protocol_for_students.id
      expect(act.protocol_subscriptions.third.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.third.filling_out_for_id).to eq students.third.id

      expect(act.protocol_subscriptions.fourth.protocol.id).to eq protocol_for_mentors.id
      expect(act.protocol_subscriptions.fourth.start_date).to be_within(1.minute).of(timedateinfuture)
      expect(act.protocol_subscriptions.fourth.filling_out_for_id).to eq act.id
    end
  end
end
