
# frozen_string_literal: true

require 'rails_helper'

module Api
  describe OrganizationOverviewSerializer do
    before :each do
      Timecop.freeze(2017, 7, 1)
    end

    let(:group) { Person::STUDENT }

    let(:overview) do
      [
        { name: 'Organization 1',
          data: { Person::STUDENT => { completed: 2, total: 20, met_threshold_completion: 1 },
                  Person::MENTOR => { completed: 10, total: 20, met_threshold_completion: 2 } } },
        { name: 'Organization 2',
          data: { Person::STUDENT => { completed: 0, total: 0, met_threshold_completion: 4 },
                  Person::MENTOR => { completed: 5, total: 10, met_threshold_completion: 3 } } },
        { name: 'Organization 3',
          data: { Person::STUDENT => { completed: 5, total: 10, met_threshold_completion: 5 },
                  Person::MENTOR => { completed: 5, total: 10, met_threshold_completion: 6 } } },
        { name: 'Organization 4',
          data: {} }
      ]
    end
    subject(:json) { described_class.new(overview, group: group).as_json.with_indifferent_access }

    describe 'renders the correct json' do
      it 'should contain the correct variables' do
        expect(json.keys).to eq(%w[overview])
      end
    end

    describe 'overview' do
      let(:names_in_json) { json['overview'].map { |org| org['name'] } }
      let(:instance_var) do
        [
          {
            name: 'Organization1',
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
            name: 'Organization2',
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
            name: 'Organization1',
            data: {
              Person::STUDENT => {
                completed: 10,
                total: 90,
                met_threshold_completion: 7
              }
            }
          },
          {
            name: 'Organization2',
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

      it 'should gracefully return an empty array if the overview var is not set' do
        result = described_class.new([], group: Person::STUDENT).as_json.with_indifferent_access
        expect(result).to be_a Hash
        expect(result.keys).to include 'overview'
        expect(result['overview']).to be_a Array
        expect(result['overview']).to be_blank
      end

      it 'should gracefully return when an organization has no mentors' do
        [Person::STUDENT, Person::MENTOR].each do |group|
          result = described_class.new(overview_no_mentors, group: group).as_json.with_indifferent_access
          result = result['overview']
          expect(result.length).to eq 2
          (0..1).each do |idx|
            expect(result[idx][:name]).to eq overview_no_mentors[idx][:name]

            if overview_no_mentors[idx][:data].keys.include? group
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

      it 'should return a hash with the correct attributes' do
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

      it 'should return a hash with the correct stats for a specified group' do
        [Person::STUDENT, Person::MENTOR].each do |group|
          result = described_class.new(instance_var, group: group).as_json.with_indifferent_access
          result = result['overview']
          expect(result.length).to eq 2
          (0..1).each do |idx|
            expect(result[idx][:name]).to eq instance_var[idx][:name]
            expect(result[idx][:completed]).to eq instance_var[idx][:data][group][:completed]
            percentage = instance_var[idx][:data][group][:completed].to_d /
                         instance_var[idx][:data][group][:total].to_d * 100.0
            expect(result[idx][:percentage_completed]).to eq percentage.round
          end
        end
      end

      it 'should not add entries for organizations without any data' do
        expect(names_in_json).to_not include(overview.last[:name])
      end

      it 'should add an instance for all organizations with data' do
        expect(names_in_json.length).to eq(3)
        expect(names_in_json).to include(overview.first[:name])
        expect(names_in_json).to include(overview.second[:name])
        expect(names_in_json).to include(overview.third[:name])
      end

      it 'should include the completed rate for each organization' do
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

      it 'should include the met_threshold rate for each organization' do
        json['overview'].each_with_index do |entry, index|
          expect(entry['name']).to eq(overview[index][:name])
          expect(entry['met_threshold_completion']).to eq(overview[index][:data][group][:met_threshold_completion])
        end
      end
    end
  end
end
