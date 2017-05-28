# frozen_string_literal: true

require 'rails_helper'

describe CreateStudents do
  let!(:protocol) { FactoryGirl.create(:protocol, name: 'protname') }
  let(:dateinfuture) { 14.days.from_now.to_date.to_s }
  let(:students) do
    [{ first_name: 'a',
       last_name: 'e',
       mobile_phone: '0612345679',
       protocol_name: 'protname',
       start_date: dateinfuture },
     { first_name: 'b',
       last_name: 'f',
       mobile_phone: '06-12345670',
       protocol_name: 'protname',
       start_date: dateinfuture },
     { first_name: 'c',
       last_name: 'g',
       mobile_phone: '0612345671',
       protocol_name: 'protname',
       start_date: dateinfuture }]
  end

  describe 'execute' do
    it 'should accept an array as string' do
      expect do
        described_class.run!(students: [])
      end.to_not raise_error
    end
  end

  describe 'parse_students' do
    it 'should return an array with all students' do
      result = subject.send(:parse_students, students)
      expect(result).to be_a(Array)
      expect(result.length).to eq 3
    end

    it 'should set the correct keys' do
      result = subject.send(:parse_students, students)
      expect(result.map(&:keys).uniq.flatten).to match_array(%i[first_name
                                                                last_name
                                                                mobile_phone
                                                                protocol_id
                                                                start_date])
    end

    it 'should set the correct data' do
      result = subject.send(:parse_students, students)
      timedateinfuture = Time.zone.parse(dateinfuture)
      expect(result.first).to eq(first_name: 'a',
                                 last_name: 'e',
                                 mobile_phone: '0612345679',
                                 protocol_id: protocol.id,
                                 start_date: timedateinfuture)
      expect(result.second).to eq(first_name: 'b',
                                  last_name: 'f',
                                  mobile_phone: '0612345670',
                                  protocol_id: protocol.id,
                                  start_date: timedateinfuture)
      expect(result.third).to eq(first_name: 'c',
                                 last_name: 'g',
                                 mobile_phone: '0612345671',
                                 protocol_id: protocol.id,
                                 start_date: timedateinfuture)
    end
  end

  describe 'create_students' do
    let(:timedateinfuture) { Time.zone.parse(dateinfuture) }
    let(:parsed_students) do
      [{ first_name: 'a',
         last_name: 'e',
         mobile_phone: '0612345679',
         protocol_id: protocol.id,
         start_date: timedateinfuture },
       { first_name: 'b',
         last_name: 'f',
         mobile_phone: '0612345670',
         protocol_id: protocol.id,
         start_date: timedateinfuture }]
    end

    it 'should create students for all hashes in the array supplied' do
      expect(Student.count).to eq 0
      subject.send(:create_students, parsed_students)
      expect(Student.count).to eq parsed_students.length
    end

    it 'should create the correct students' do
      subject.send(:create_students, parsed_students)
      parsed_students.each do |hash|
        act = Student.find_by_mobile_phone(hash[:mobile_phone])
        expect(act.first_name).to eq hash[:first_name]
        expect(act.last_name).to eq hash[:last_name]
        expect(act.mobile_phone).to eq hash[:mobile_phone]
        expect(act.protocol_subscriptions.first.protocol.id).to eq protocol.id
        expect(act.protocol_subscriptions.first.start_date).to be_within(1.minute).of(timedateinfuture)
      end
    end

    it 'should just skip if a person with that phone number already exists' do
      parsed_students << { first_name: 'x',
                           last_name: 'z',
                           mobile_phone: '0612345679',
                           protocol_id: protocol.id,
                           start_date: timedateinfuture }
      subject.send(:create_students, parsed_students)
      expect(Student.count).to eq parsed_students.length - 1
    end
  end
end
