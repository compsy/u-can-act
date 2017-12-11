# frozen_string_literal: true

require 'rails_helper'

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
