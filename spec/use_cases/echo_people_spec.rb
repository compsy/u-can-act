# frozen_string_literal: true

require 'rails_helper'

describe EchoPeople do
  let(:filename) { 'some_file.csv' }

  describe 'execute' do
    it 'accepts a file_name as string' do
      expect_any_instance_of(described_class).to receive(:execute).and_return true
      expect do
        described_class.run!(file_name: filename)
      end.not_to raise_error
    end

    it 'tests whether a file exists' do
      expect_any_instance_of(described_class).to receive(:assert_file_existence).with(filename).and_return true
      expect_any_instance_of(described_class).to receive(:echo_people).with(filename)
      expect do
        described_class.run!(file_name: filename)
      end.not_to raise_error
    end
  end

  describe 'assert_file_existence' do
    it 'does not raise if the file does exist' do
      expect(File).to receive(:file?).and_return(true)
      expect { subject.send(:assert_file_existence, 'existing.csv') }.not_to raise_error
    end

    it 'raises RuntimeError when the file does not exist' do
      expect do
        subject.send(:assert_file_existence, 'some_file.csv')
      end.to raise_error(RuntimeError, /does not exist/)
    end
  end

  describe 'echo_people' do
    let!(:protocol) { FactoryBot.create(:protocol, name: 'protname') }
    let(:dateinfuture) { 14.days.from_now.to_date.to_s }
    let(:enddateinfuture) { 42.days.from_now.to_date.to_s }

    describe 'with students' do
      before do
        allow(CSV).to receive(:foreach)
          .and_yield(%w[type team_name role_title firstname lastname gender
                        mobile_phone protocol_name start_date end_date])
          .and_yield([Person::STUDENT, 'mijnschool', 'x', '   a   ', ' e', Person::MALE,
                      '0612345679', 'email1@email.com', 'protname', dateinfuture, enddateinfuture])
          .and_yield([Person::STUDENT, 'mijnschool', 'y',  'b', 'f   ', Person::FEMALE,
                      '06-12345670', 'email2@email.com', 'protname', dateinfuture, enddateinfuture])
          .and_yield([Person::STUDENT, 'mijnschool', 'z',  'c  ', '  g  ', Person::MALE,
                      '0612345671', 'email3@email.com', 'protname', dateinfuture, enddateinfuture])
      end

      it 'returns an array with all people (except the header)' do
        expected_output = "people = [];nil\n"
        expected_output += 'people << {:team_name=>"mijnschool", :role_title=>"x", :first_name=>"a", '\
                           ':last_name=>"e", :gender=>"male", :mobile_phone=>"0612345679", ' \
                           ':email=>"email1@email.com", ' \
                           ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\", " \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"mijnschool", :role_title=>"y", :first_name=>"b", ' \
                           ':last_name=>"f", :gender=>"female", :mobile_phone=>"06-12345670", ' \
                           ':email=>"email2@email.com", ' \
                           ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\", " \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"mijnschool", :role_title=>"z", :first_name=>"c", ' \
                           ':last_name=>"g", :gender=>"male", :mobile_phone=>"0612345671", ' \
                           ':email=>"email3@email.com", ' \
                           ":protocol_name=>\"protname\", :start_date=>\"#{dateinfuture}\", " \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expect { subject.send(:echo_people, 'test.csv') }.to output(expected_output).to_stdout
      end
    end

    describe 'with mentors' do
      before do
        allow(CSV).to receive(:foreach)
          .and_yield(%w[type team_name role_title
                        firstname lastname gender
                        mobile_phone email protocol_name start_date])
          .and_yield([Person::MENTOR, 'jouwschool', Person::MENTOR, 'a',
                      'e', Person::MALE, '0612345679', 'mentor1@test.com',
                      'protname', dateinfuture, '06-12345670', 'pilot', enddateinfuture])
          .and_yield([Person::MENTOR, 'jouwschool', Person::MENTOR, 'a',
                      'e', Person::FEMALE, '0612345679', 'mentor2@test.com',
                      'protname', dateinfuture, '0676543219', 'pilot', enddateinfuture])
          .and_yield([Person::MENTOR, 'jouwschool', Person::MENTOR, 'b',
                      'f', Person::MALE, '06-12345670', 'mentor3@test.com',
                      'protname', dateinfuture, '0676543219', 'pilot', enddateinfuture])
          .and_yield([Person::MENTOR, 'jouwschool', Person::MENTOR, 'b',
                      'f', Person::FEMALE, '06-12345670', 'mentor4@test.com',
                      'protname', dateinfuture, '0676543266', 'pilot', enddateinfuture])
          .and_yield([Person::MENTOR, 'jouwschool', Person::MENTOR, 'b',
                      'f', Person::MALE, '06-12345670', 'mentor5@test.com',
                      'protname', dateinfuture, '0676543227', 'pilot', enddateinfuture])
      end

      it 'returns an array with all mentors (except the header)' do
        expected_output = "people = [];nil\n"
        expected_output += 'people << {:team_name=>"jouwschool", ' \
                           ':role_title=>"Mentor", :first_name=>"a", :last_name=>"e", ' \
                           ':gender=>"male", :mobile_phone=>"0612345679", ' \
                           ':email=>"mentor1@test.com", :protocol_name=>"protname", ' \
                           ":start_date=>\"#{dateinfuture}\", " \
                           ':filling_out_for=>"06-12345670", :filling_out_for_protocol=>"pilot", ' \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"jouwschool", ' \
                           ':role_title=>"Mentor", :first_name=>"a", :last_name=>"e", ' \
                           ':gender=>"female", :mobile_phone=>"0612345679", ' \
                           ':email=>"mentor2@test.com", :protocol_name=>"protname", ' \
                           ":start_date=>\"#{dateinfuture}\", " \
                           ':filling_out_for=>"0676543219", :filling_out_for_protocol=>"pilot", ' \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"jouwschool", ' \
                           ':role_title=>"Mentor", :first_name=>"b", :last_name=>"f", ' \
                           ':gender=>"male", :mobile_phone=>"06-12345670", ' \
                           ':email=>"mentor3@test.com", :protocol_name=>"protname", ' \
                           ":start_date=>\"#{dateinfuture}\", " \
                           ':filling_out_for=>"0676543219", :filling_out_for_protocol=>"pilot", ' \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"jouwschool", ' \
                           ':role_title=>"Mentor", :first_name=>"b", :last_name=>"f", ' \
                           ':gender=>"female", :mobile_phone=>"06-12345670", ' \
                           ':email=>"mentor4@test.com", :protocol_name=>"protname", ' \
                           ":start_date=>\"#{dateinfuture}\", " \
                           ':filling_out_for=>"0676543266", :filling_out_for_protocol=>"pilot", ' \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"
        expected_output += 'people << {:team_name=>"jouwschool", ' \
                           ':role_title=>"Mentor", :first_name=>"b", :last_name=>"f", ' \
                           ':gender=>"male", :mobile_phone=>"06-12345670", ' \
                           ':email=>"mentor5@test.com", :protocol_name=>"protname", ' \
                           ":start_date=>\"#{dateinfuture}\", " \
                           ':filling_out_for=>"0676543227", :filling_out_for_protocol=>"pilot", ' \
                           ":end_date=>\"#{enddateinfuture}\"};nil\n"

        expect { subject.send(:echo_people, 'test.csv') }.to output(expected_output).to_stdout
      end
    end
  end
end
