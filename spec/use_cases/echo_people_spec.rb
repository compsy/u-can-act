# frozen_string_literal: true

require 'rails_helper'

describe EchoPeople do
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
      expect_any_instance_of(described_class).to receive(:echo_people).with(filename)
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

  describe 'echo_people' do
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
      expected_output = "people = [];nil\n"
      expected_output += 'people << {:first_name=>"a", :last_name=>"e", :mobile_phone=>"0612345679", ' \
                        ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\"};nil\n"
      expected_output += 'people << {:first_name=>"b", :last_name=>"f", :mobile_phone=>"06-12345670", ' \
                        ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\"};nil\n"
      expected_output += 'people << {:first_name=>"c", :last_name=>"g", :mobile_phone=>"0612345671", ' \
                        ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\"};nil\n"
      expect { subject.send(:echo_people, 'test.csv') }.to output(expected_output).to_stdout
    end
  end
end
