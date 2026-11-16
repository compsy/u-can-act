# frozen_string_literal: true

require 'rails_helper'

describe 'rake maintenance:echo_people', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully without protocols or responses' do
    expect do
      expect do
        task.execute(csv_file: 'somefile.csv')
      end.to output("Echoing people from 'somefile.csv' - started\n" \
                    "Echoing people from 'somefile.csv' - done\n").to_stdout
    end.to raise_error(RuntimeError, 'File somefile.csv does not exist')
  end

  it 'calls the echo people use case with the given filename' do
    expect(EchoPeople).to receive(:run!).with(file_name: 'somefile.csv')
    expect do
      task.execute(csv_file: 'somefile.csv')
    end.to output("Echoing people from 'somefile.csv' - started\n" \
                  "Echoing people from 'somefile.csv' - done\n").to_stdout
  end
end

describe 'rake maintenance:fix_responses', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the fix responses use case' do
    expect(FixResponses).to receive(:run!)
    expect do
      task.execute
    end.to output("Fixing responses - started\n" \
                  "Fixing responses - done\n").to_stdout
  end
end

describe 'rake maintenance:scramble', type: :task do
  let!(:persons) { FactoryBot.create_list(:person, 10) }
  let!(:students) { FactoryBot.create_list(:student, 10) }
  let!(:mentors) { FactoryBot.create_list(:mentor, 10) }

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'sends the correct logging' do
    expect do
      task.execute
    end.to output("Scrambling people - started\n" \
                  "Scrambling people - done\n").to_stdout
  end

  describe 'should scramble' do
    let!(:ids) { Person.all.map(&:id) }
    let!(:pre_people) { Person.all.map(&:dup) }

    it 'names' do
      task.execute
      pre_people.each_with_index do |person, idx|
        id = ids[idx]
        other_person = Person.find(id)
        expect(other_person.first_name).not_to eq person.first_name
        expect(other_person.last_name).not_to eq person.last_name
      end
    end

    it 'mobile phone numbers' do
      task.execute

      pre_people.each_with_index do |person, idx|
        id = ids[idx]
        other_person = Person.find(id)
        expect(other_person.mobile_phone).not_to eq person.mobile_phone
      end
    end

    it 'email addresses' do
      task.execute

      pre_people.each_with_index do |person, idx|
        id = ids[idx]
        other_person = Person.find(id)
        expect(other_person.email).not_to eq person.email
      end
    end

    it 'iban' do
      task.execute

      pre_people.each_with_index do |person, idx|
        id = ids[idx]
        other_person = Person.find(id)
        if person.mentor?
          expect(other_person.iban).to be_blank
        else
          expect(other_person.iban).not_to eq person.iban
        end
      end
    end
  end
end

describe 'rake maintenance:audit_mobile_phones', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'reports when all numbers are allowed' do
    FactoryBot.create(:person, mobile_phone: '0612345678')
    FactoryBot.create(:person, mobile_phone: nil)
    expect { task.execute }.to output("People with a mobile phone number: 1\n" \
                                      "People with a mobile phone number that is no longer allowed: 0\n").to_stdout
  end

  it 'counts the numbers that are no longer allowed, grouped by prefix, without changing them' do
    FactoryBot.create(:person, mobile_phone: '0612345678')
    FactoryBot.create(:person, mobile_phone: '+32470123456')
    old_numbers = ['+49 170 1234567', '+491701234568', '0470123456']
    old_numbers.each do |number|
      FactoryBot.build(:person, mobile_phone: number).save!(validate: false)
    end
    expect { task.execute }.to output("People with a mobile phone number: 5\n" \
                                      "People with a mobile phone number that is no longer allowed: 3\n" \
                                      "By first three characters (spaces and hyphens removed):\n  " \
                                      "+49: 2\n  " \
                                      "047: 1\n").to_stdout
    expect(Person.where(mobile_phone: old_numbers).count).to eq 3
  end
end
