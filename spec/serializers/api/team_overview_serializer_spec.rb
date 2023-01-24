# frozen_string_literal: true

require 'rails_helper'

describe Api::TeamOverviewSerializer do
  subject(:json) { described_class.new(overview, group: group).as_json.with_indifferent_access }

  before do
    Timecop.freeze(2017, 7, 1)
  end

  let(:group) { Person::STUDENT }

  let(:overview) do
    [
      { name: 'Team 1',
        data: { Person::STUDENT => { completed: 2, total: 20, met_threshold_completion: 1 },
                Person::MENTOR => { completed: 10, total: 20, met_threshold_completion: 2 } } },
      { name: 'Team 2',
        data: { Person::STUDENT => { completed: 0, total: 0, met_threshold_completion: 4 },
                Person::MENTOR => { completed: 5, total: 10, met_threshold_completion: 3 } } },
      { name: 'Team 3',
        data: { Person::STUDENT => { completed: 5, total: 10, met_threshold_completion: 5 },
                Person::MENTOR => { completed: 5, total: 10, met_threshold_completion: 6 } } },
      { name: 'Team 4',
        data: {} }
    ]
  end

  describe 'renders the correct json' do
    it 'contains the correct variables' do
      expect(json.keys).to eq(%w[overview])
    end
  end

  describe 'overview' do
    let(:names_in_json) { json['overview'].pluck('name') }
    let(:instance_var) do
      [
        {
          name: 'Team1',
          data: {
            Person::STUDENT => {
              completed: 10,
              total: 90,
              met_threshold_completion: 1
            },
            Person::MENTOR => {
              completed: 11,
              total: 95,
              met_threshold_completion: 10
            }
          }
        },
        {
          name: 'Team2',
          data: {
            Person::STUDENT => {
              completed: 0,
              total: 20,
              met_threshold_completion: 18
            },
            Person::MENTOR => {
              completed: 21,
              total: 50,
              met_threshold_completion: 8
            }
          }
        }
      ]
    end
    let(:overview_no_mentors) do
      [
        {
          name: 'Team1',
          data: {
            Person::STUDENT => {
              completed: 10,
              total: 90,
              met_threshold_completion: 7
            }
          }
        },
        {
          name: 'Team2',
          data: {
            Person::STUDENT => {
              completed: 0,
              total: 20,
              met_threshold_completion: 4
            },
            Person::MENTOR => {
              completed: 21,
              total: 50,
              met_threshold_completion: 6
            }
          }
        }
      ]
    end

    it 'gracefullies return an empty array if the overview var is not set' do
      result = described_class.new([], group: Person::STUDENT).as_json.with_indifferent_access
      expect(result).to be_a Hash
      expect(result.keys).to include 'overview'
      expect(result['overview']).to be_a Array
      expect(result['overview']).to be_blank
    end

    it 'gracefullies return when an team has no mentors' do
      [Person::STUDENT, Person::MENTOR].each do |group|
        result = described_class.new(overview_no_mentors, group: group).as_json.with_indifferent_access
        result = result['overview']
        expect(result.length).to eq 2
        2.times do |idx|
          expect(result[idx][:name]).to eq overview_no_mentors[idx][:name]

          if overview_no_mentors[idx][:data].key?(group)
            completed_expected = overview_no_mentors[idx][:data][group][:completed]

            percentage = overview_no_mentors[idx][:data][group][:completed].to_d /
                         overview_no_mentors[idx][:data][group][:total].to_d * 100.0
            percentage_expected = percentage.round
          else
            completed_expected = 0.0
            percentage_expected = 0
          end
          expect(result[idx][:completed]).to eq completed_expected
          expect(result[idx][:percentage_completed]).to eq percentage_expected
        end
      end
    end

    it 'returns a hash with the correct attributes' do
      [Person::STUDENT, Person::MENTOR].each do |group|
        result = described_class.new(instance_var, group: group).as_json.with_indifferent_access
        expect(result.keys).to include 'overview'

        result = result['overview']
        expect(result.length).to eq 2

        result.each do |entry|
          expect(entry.keys).to match_array %w[name completed met_threshold_completion
                                               percentage_above_threshold percentage_completed]
        end
      end
    end

    it 'returns a hash with the correct stats for a specified group' do
      [Person::STUDENT, Person::MENTOR].each do |group|
        result = described_class.new(instance_var, group: group).as_json.with_indifferent_access
        result = result['overview']
        expect(result.length).to eq 2
        2.times do |idx|
          expect(result[idx][:name]).to eq instance_var[idx][:name]
          expect(result[idx][:completed]).to eq instance_var[idx][:data][group][:completed]
          percentage = instance_var[idx][:data][group][:completed].to_d /
                       instance_var[idx][:data][group][:total].to_d * 100.0
          expect(result[idx][:percentage_completed]).to eq percentage.round
        end
      end
    end

    it 'does not add entries for teams without any data' do
      expect(names_in_json).not_to include(overview.last[:name])
    end

    it 'adds an instance for all teams with data' do
      expect(names_in_json.length).to eq(3)
      expect(names_in_json).to include(overview.first[:name])
      expect(names_in_json).to include(overview.second[:name])
      expect(names_in_json).to include(overview.third[:name])
    end

    it 'includes the completed rate for each team' do
      json['overview'].each_with_index do |entry, index|
        expect(entry['name']).to eq(overview[index][:name])
        expect(entry['completed']).to eq(overview[index][:data][group][:completed])
        total = overview[index][:data][group][:total]
        perc = 0
        if total > 0.0
          perc = overview[index][:data][group][:completed].to_d / overview[index][:data][group][:total].to_d
          perc *= 100.0
        end
        expect(entry['percentage_completed']).to eq(perc)
      end
    end

    it 'includes the met_threshold rate for each team' do
      json['overview'].each_with_index do |entry, index|
        expect(entry['name']).to eq(overview[index][:name])
        expect(entry['met_threshold_completion']).to eq(overview[index][:data][group][:met_threshold_completion])
      end
    end
  end
end
