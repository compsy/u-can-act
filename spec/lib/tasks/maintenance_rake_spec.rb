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
