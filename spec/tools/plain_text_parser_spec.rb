require 'rails_helper'

describe PlainTextParser, focus: true do
  let(:mobile_phone) { '0612312344' }
  describe 'parse_mobile_phone' do
    it 'should replace hyphens with nothing in a phone number' do
      phone_number = '06-12341234'
      result = subject.parse_mobile_phone(phone_number)
      expect(result).to eq '0612341234'
    end

    it 'should throw if the number is ! 10 chars' do
      wrong_phone_number = '06123412341'
      expect {subject.parse_mobile_phone(wrong_phone_number)}
        .to raise_error(RuntimeError,"Phone number is not 10 characters long: #{wrong_phone_number}")
      wrong_phone_number = '06123413'
      expect {subject.parse_mobile_phone(wrong_phone_number)}
        .to raise_error(RuntimeError,"Phone number is not 10 characters long: #{wrong_phone_number}")
    end

    it 'should throw if the number doesnt start with 06' do
      wrong_phone_number = '1234123412'
      expect {subject.parse_mobile_phone(wrong_phone_number)}
        .to raise_error(RuntimeError, "Phone number does not start with 06: #{wrong_phone_number}")
      wrong_phone_number = '1230623412'
      expect {subject.parse_mobile_phone(wrong_phone_number)}
        .to raise_error(RuntimeError, "Phone number does not start with 06: #{wrong_phone_number}")
    end

    it 'should return the phone number if everything is correct' do
      result = subject.parse_mobile_phone(mobile_phone)
      expect(result).to eq mobile_phone
    end
  end

  describe 'parse_protocol_name' do
    it 'should raise if the protocol does not exist' do
      protocol_name = 'something random'
      expect {subject.parse_protocol_name(protocol_name)}.to raise_error(
        RuntimeError, "No protocol exists by that name: #{protocol_name}"
      )
    end

    it 'should return the protocol id if everything is correct' do
      protocol = FactoryGirl.create(:protocol)
      expect(subject.parse_protocol_name(protocol.name)).to eq(protocol.id)
    end
  end

  describe 'parse_start_date' do
    it 'should raise if the start date is not beginning of day' do
      start_date = '29-5-2017 0:01'
      expect {subject.parse_start_date(start_date)}.to raise_error(
        RuntimeError, "Start date is not beginning of day: #{start_date}"
      )
    end

    it 'should throw if the date is unparsable' do
      start_date = 'something random'
      expect {subject.parse_start_date(start_date)}.to raise_error(
        RuntimeError, "Start date is not in the correct format: #{start_date}"
      )
    end

    it 'should retrun the correct start date (in rails time format) if everything is correct' do
      start_date = '29-5-2017 0:00'
      result = subject.parse_start_date(start_date)
      expected = Time.zone.parse(start_date)
      expect(result).to be_a Time
      expect(result).to eq expected
    end
  end

  describe 'parse_filling_out_for' do
    let(:student_mobile_phone) { '0612312344' }
    let(:mentor_mobile_phone) { '0612312355' }

    it 'should raise if the filling out for person does not exist' do
      allow(subject).to receive(:parse_mobile_phone).and_return(mobile_phone)
      expect {subject.parse_filling_out_for('random') } .to raise_error(
        RuntimeError, "Person #{mobile_phone} does not exist"
      )
    end

    describe 'with the correct person' do
      let!(:student) { FactoryGirl.create(:student, mobile_phone: student_mobile_phone) }
      let!(:mentor) { FactoryGirl.create(:mentor, mobile_phone: mentor_mobile_phone ) }

      it 'should call the parse mobile phone function' do
        expect(subject).to receive(:parse_mobile_phone).and_return(student_mobile_phone)
        subject.parse_filling_out_for(student_mobile_phone)
      end

      it 'should raise if the person filling out for is not a student' do
        expect {subject.parse_filling_out_for(mentor_mobile_phone)}.to raise_error(
          RuntimeError, "Person #{mentor_mobile_phone} is not a student"
        )
      end

      it 'should return the person if everything is correct' do
        result = subject.parse_filling_out_for(student_mobile_phone)
        expect(result).to be_a Person
        expect(result).to be_a Student
        expect(result.mobile_phone).to eq student_mobile_phone
      end
    end
  end
end
