
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
          data: { Person::STUDENT => { completed: 2, total: 20 }, Person::MENTOR => { completed: 10, total: 20 } } },
        { name: 'Organization 2',
          data: { Person::STUDENT => { completed: 0, total: 0 }, Person::MENTOR => { completed: 5, total: 10 } } },
        { name: 'Organization 3',
          data: { Person::STUDENT => { completed: 5, total: 10 }, Person::MENTOR => { completed: 5, total: 10 } } },
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
    end
  end
end
