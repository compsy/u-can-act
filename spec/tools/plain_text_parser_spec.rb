# frozen_string_literal: true

require 'rails_helper'

describe PlainTextParser do
  let(:mobile_phone) { '0612312344' }

  describe 'parse_mobile_phone' do
    it 'replaces hyphens with nothing in a phone number' do
      phone_number = '06-12341234'
      result = subject.parse_mobile_phone(phone_number)
      expect(result).to eq '0612341234'
    end

    it 'throws if the number is ! 10 chars' do
      wrong_phone_number = '06123412341'
      expect { subject.parse_mobile_phone(wrong_phone_number) }
        .to raise_error(RuntimeError, "Phone number is not 10 characters long: #{wrong_phone_number}")
      wrong_phone_number = '06123413'
      expect { subject.parse_mobile_phone(wrong_phone_number) }
        .to raise_error(RuntimeError, "Phone number is not 10 characters long: #{wrong_phone_number}")
    end

    it 'throws if the number doesnt start with 06' do
      wrong_phone_number = '1234123412'
      expect { subject.parse_mobile_phone(wrong_phone_number) }
        .to raise_error(RuntimeError, "Phone number does not start with 06: #{wrong_phone_number}")
      wrong_phone_number = '1230623412'
      expect { subject.parse_mobile_phone(wrong_phone_number) }
        .to raise_error(RuntimeError, "Phone number does not start with 06: #{wrong_phone_number}")
    end

    it 'returns the phone number if everything is correct' do
      result = subject.parse_mobile_phone(mobile_phone)
      expect(result).to eq mobile_phone
    end

    it 'should raise an error if a phone number is blank' do
      ['', nil].each do |phone_number|
        expect { subject.parse_mobile_phone(phone_number) }.to raise_error(/Phone number is blank/)
      end
    end
  end

  describe 'parse_protocol_name' do
    it 'raises if the protocol does not exist' do
      protocol_name = 'something random'
      expect { subject.parse_protocol_name(protocol_name) }.to raise_error(
        RuntimeError, "No protocol exists by that name: #{protocol_name}"
      )
    end

    it 'returns the protocol id if everything is correct' do
      protocol = FactoryBot.create(:protocol)
      expect(subject.parse_protocol_name(protocol.name)).to eq(protocol.id)
    end
  end

  describe 'parse_team_name' do
    it 'raises if the team does not exist' do
      team_name = 'something random'
      expect { subject.parse_team_name(team_name) }.to raise_error(
        RuntimeError, "No team exists by that name: #{team_name}"
      )
    end

    it 'returns the team if everything is correct' do
      team = FactoryBot.create(:team)
      expect(subject.parse_team_name(team.name)).to eq(team)
    end
  end

  describe 'parse_role_name' do
    it 'raises if the role does not exist in the team' do
      team = FactoryBot.create(:team)
      role = FactoryBot.create(:role)
      expect { subject.parse_role_title(team.name, role.title) }.to raise_error(
        RuntimeError, "No role exists in that team by that title: #{role.title}"
      )
    end

    it 'returns the role id if everything is correct' do
      role = FactoryBot.create(:role)
      expect(subject.parse_role_title(role.team.name, role.title)).to eq(role.id)
    end
  end

  describe 'parse_start_date' do
    it 'raises if the start date is not beginning of day' do
      start_date = '29-5-2017 0:01'
      expect { subject.parse_start_date(start_date) }.to raise_error(
        RuntimeError, "Start date is not beginning of day: #{start_date}"
      )
    end

    it 'throws if the date is unparsable' do
      start_date = 'something random'
      expect { subject.parse_start_date(start_date) }.to raise_error(
        RuntimeError, "Start date is not in the correct format: #{start_date}"
      )
    end

    it 'retruns the correct start date (in rails time format) if everything is correct' do
      start_date = '29-5-2017 0:00'
      result = subject.parse_start_date(start_date)
      expected = Time.zone.parse(start_date)
      expect(result).to be_a Time
      expect(result).to eq expected
    end
  end

  describe 'parse_end_date' do
    before do
      Timecop.freeze(2017, 4, 1)
    end

    after do
      Timecop.return
    end

    it 'raises if the end date is in the past' do
      end_date = '29-3-2017 0:00'
      expect { subject.parse_end_date(end_date) }.to raise_error(
        RuntimeError, "End date lies in the past: #{end_date}"
      )
    end

    it 'raises if the end date is not beginning of day' do
      end_date = '29-5-2017 0:01'
      expect { subject.parse_end_date(end_date) }.to raise_error(
        RuntimeError, "End date is not beginning of day: #{end_date}"
      )
    end

    it 'throws if the date is unparsable' do
      end_date = 'something random'
      expect { subject.parse_end_date(end_date) }.to raise_error(
        RuntimeError, "End date is not in the correct format: #{end_date}"
      )
    end

    it 'retruns the correct end date (in rails time format) if everything is correct' do
      end_date = '29-5-2017 0:00'
      result = subject.parse_end_date(end_date)
      expected = Time.zone.parse(end_date)
      expect(result).to be_a Time
      expect(result).to eq expected
    end
  end

  describe 'parse_filling_out_for' do
    let(:student_mobile_phone) { '0612312344' }
    let(:mentor_mobile_phone) { '0612312355' }

    it 'raises if the filling out for person does not exist' do
      allow(subject).to receive(:parse_mobile_phone).and_return(mobile_phone)
      expect { subject.parse_filling_out_for('random') }.to raise_error(
        RuntimeError, "Person #{mobile_phone} does not exist"
      )
    end

    describe 'with the correct person' do
      let!(:student) { FactoryBot.create(:student, mobile_phone: student_mobile_phone) }
      let!(:mentor) { FactoryBot.create(:mentor, mobile_phone: mentor_mobile_phone) }

      it 'calls the parse mobile phone function' do
        expect(subject).to receive(:parse_mobile_phone).and_return(student_mobile_phone)
        subject.parse_filling_out_for(student_mobile_phone)
      end

      it 'raises if the person filling out for is not a student' do
        expect { subject.parse_filling_out_for(mentor_mobile_phone) }.to raise_error(
          RuntimeError, "Person #{mentor_mobile_phone} is not a student"
        )
      end

      it 'returns the person if everything is correct' do
        result = subject.parse_filling_out_for(student_mobile_phone)
        expect(result).to eq student.id
      end
    end
  end
end
