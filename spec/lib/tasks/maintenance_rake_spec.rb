# frozen_string_literal: true

require 'rails_helper'

describe 'rake maintenance:reschedule_posttests', type: :task do
  it 'should preload the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'should run gracefully without protocols or responses' do
    expect { expect { task.execute }.to output(/Adjusted 0 protocols/).to_stdout }.not_to(raise_error)
  end

  it 'should reschedule existing protocols that have 3 weeks duration' do
    FactoryGirl.create_list(:protocol, 11, duration: 2.weeks)
    FactoryGirl.create_list(:protocol, 7, duration: 3.weeks)
    FactoryGirl.create_list(:protocol, 19, duration: 4.weeks)
    protocolcountbef = Protocol.count
    expect { task.execute }.to output(/Adjusted 7 protocols/).to_stdout
    expect(Protocol.count).to eq protocolcountbef
    expect(Protocol.where(duration: 2.weeks).count).to eq 11
    expect(Protocol.where(duration: 3.weeks).count).to eq 0
    expect(Protocol.where(duration: 4.weeks).count).to eq(7 + 19)
  end

  it 'should reschedule the nametingen' do
    questionnaire_names = [
      'nameting studenten 1x per week',
      'nameting studenten 2x per week',
      'nameting studenten 5x per week',
      'nameting mentoren 1x per week',
      'other questionnaire'
    ]
    questionnaires = []
    measurements = []
    responses = []
    unadjusted_open_from = TimeTools.increase_by_duration(Time.new(2017, 4, 10, 0, 0, 0).in_time_zone, 1.week)
    adjusted_open_from = TimeTools.increase_by_duration(Time.new(2017, 4, 10, 0, 0, 0).in_time_zone,
                                                        2.weeks + 4.days + 13.hours)
    questionnaire_names.each do |questionnaire_name|
      questionnaires << FactoryGirl.create(:questionnaire, name: questionnaire_name)
      measurements << FactoryGirl.create(:measurement, questionnaire: questionnaires.last, open_from_offset: 1.week)
      responses << FactoryGirl.create(:response, measurement: measurements.last, open_from: unadjusted_open_from)
    end
    responsecountbef = Response.count
    expect { task.execute }.to output(/Rescheduled 4 responses/).to_stdout
    expect(Response.count).to eq responsecountbef
    Response.all.each do |response|
      if response.measurement.questionnaire.name.match?(/nameting/)
        expect(response.open_from).to be_within(1.minute).of(adjusted_open_from)
      else
        expect(response.open_from).to be_within(1.minute).of(unadjusted_open_from)
      end
    end
  end
end

describe 'rake maintenance:echo_people', type: :task do
  it 'should preload the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'should run gracefully without protocols or responses' do
    expect do
      expect do
        task.execute(csv_file: 'somefile.csv')
      end.to output("Echoing people from 'somefile.csv' - started\n" \
                    "Echoing people from 'somefile.csv' - done\n").to_stdout
    end.to raise_error(RuntimeError, 'File somefile.csv does not exist')
  end

  it 'should call the echo people use case with the given filename' do
    expect(EchoPeople).to receive(:run!).with(file_name: 'somefile.csv')
    expect do
      task.execute(csv_file: 'somefile.csv')
    end.to output("Echoing people from 'somefile.csv' - started\n" \
                  "Echoing people from 'somefile.csv' - done\n").to_stdout
  end
end
