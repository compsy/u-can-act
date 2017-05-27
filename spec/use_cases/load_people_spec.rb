# frozen_string_literal: true

require 'rails_helper'

describe LoadPeople do
  let(:filename) { 'some_file.csv' }
  describe 'execute' do
    it 'should accept a file_name as string' do
      expect_any_instance_of(described_class).to receive(:execute).and_return true
      expect do
        described_class.run!(file_name: filename)
      end.to_not raise_error
    end

    it 'should test whether a file exists' do
      expect_any_instance_of(described_class).to receive(:assert_file_existence).with(filename).and_return true
      expect_any_instance_of(described_class).to receive(:read_csv_into_people).and_return([])
      expect do
        described_class.run!(file_name: filename)
      end.to_not raise_error
    end
  end

  describe 'assert_file_existence' do
    it 'should not raise if the file does exist' do
      expect(File).to receive(:file?).and_return(true)
      expect { subject.send(:assert_file_existence, 'existing.csv') }.to_not raise_error
    end

    it 'should raise RuntimeError when the file does not exist' do
      expect do
        subject.send(:assert_file_existence, 'some_file.csv')
      end.to raise_error(RuntimeError, /does not exist/)
    end
  end

  describe 'read_csv_into_people' do
    let!(:protocol) { FactoryGirl.create(:protocol, name: 'protname') }
    let(:dateinfuture) { 14.days.from_now.to_date.to_s }
    before do
      allow(CSV).to receive(:foreach)
        .and_yield(%w[firstname lastname mobile_phone protocol_name start_date])
        .and_yield(['a', 'e', '0612345679', 'protname', dateinfuture])
        .and_yield(['b', 'f', '06-12345670', 'protname', dateinfuture])
        .and_yield(['c', 'g', '0612345671', 'protname', dateinfuture])
    end

    it 'should return an array with all people (except the header)' do
      result = subject.send(:read_csv_into_people, 'test.csv')
      expect(result).to be_a(Array)
      expect(result.length).to eq 3
    end

    it 'should set the correct keys' do
      result = subject.send(:read_csv_into_people, 'test.csv')
      expect(result.map(&:keys).uniq.flatten).to match_array(%i[first_name
                                                                last_name
                                                                mobile_phone
                                                                protocol_id
                                                                start_date])
    end

    it 'should set the correct data' do
      result = subject.send(:read_csv_into_people, 'test.csv')
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

  describe 'create_people' do
    let!(:protocol) { FactoryGirl.create(:protocol, name: 'protname') }
    let(:dateinfuture) { 14.days.from_now.to_date.to_s }
    let(:timedateinfuture) { Time.zone.parse(dateinfuture) }
    let(:people) do
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

    it 'should create people for all hashes in the array supplied' do
      expect(Student.count).to eq 0
      subject.send(:create_people, people)
      expect(Student.count).to eq people.length
    end

    it 'should create the correct people' do
      subject.send(:create_people, people)
      people.each do |hash|
        act = Student.find_by_mobile_phone(hash[:mobile_phone])
        expect(act.first_name).to eq hash[:first_name]
        expect(act.last_name).to eq hash[:last_name]
      end
    end

    it 'should just skip if a person with that phone number already exists' do
      people << { first_name: 'x',
                  last_name: 'z',
                  mobile_phone: '0612345679',
                  protocol_id: protocol.id,
                  start_date: timedateinfuture }
      subject.send(:create_people, people)
      expect(Student.count).to eq people.length - 1
    end
  end
end
