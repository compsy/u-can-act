# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      organization = FactoryBot.create(:organization)
      expect(organization).to be_valid
    end

    describe 'name' do
      it 'should be invalid when not present' do
        organization = FactoryBot.build(:organization, name: nil)
        expect(organization).to_not be_valid
        organization = FactoryBot.build(:organization, name: 'test name')
        expect(organization).to be_valid
      end

      it 'should be invalid when not unique' do
        FactoryBot.create(:organization, name: 'test')
        organization2 = FactoryBot.build(:organization, name: 'test')
        expect(organization2).to_not be_valid
      end
    end
  end

  it 'should be able to retrieve teams' do
    organization = FactoryBot.create(:organization, :with_teams)
    expect(organization.teams.to_a).to be_a(Array)
    organization.teams.each do |role|
      expect(role).to be_a(Team)
    end
  end

  describe 'overview_key' do
    before :each do
      Timecop.freeze(2017, 5, 5)
    end

    it 'should return a key based on the current week and year if no week or year is provided' do
      result = described_class.overview_key
      year = 2017
      week_number = 18
      expected = "#{described_class::ORGANIZATION_OVERVIEW_BASE_KEY}_#{year}_#{week_number}"
      expect(result).to eq expected
    end

    it 'should return a key with the provided week and year' do
      year = 2013
      week_number = 10
      result = described_class.overview_key(week_number, year)
      expected = "#{described_class::ORGANIZATION_OVERVIEW_BASE_KEY}_#{year}_#{week_number}"
      expect(result).to eq expected
    end
  end

  describe 'self.overview' do
    describe 'with the caching function' do
      it 'calls the cacher with the correct parameters' do
        key = described_class.overview_key
        bust_cache = true
        expect(RedisCachedCall).to receive(:cache).with(key, bust_cache) do |&block|
          expect(block).to_not be_nil
        end
        described_class.overview(bust_cache: bust_cache)
      end
      it 'by default it should call the method with bust cache is false' do
        key = described_class.overview_key
        bust_cache = false
        expect(RedisCachedCall).to receive(:cache).with(key, bust_cache) do |&block|
          expect(block).to_not be_nil
        end
        described_class.overview
      end
    end

    describe 'without the caching function' do
      it 'should work without any organizations' do
        expect(Organization.count).to be 0
        result = described_class.overview(bust_cache: true)
        expect(result).to_not be_nil
        expect(result).to be_an Array
        expect(result).to be_blank
      end

      it 'should return an array of hashes, one for each organization' do
        organizations = FactoryBot.create_list(:organization, 2, :with_teams)
        result = described_class.overview(bust_cache: true)
        expect(result).to_not be_nil
        expect(result).to be_an Array
        expect(result).to_not be_blank
        expect(result.length).to eq organizations.length
        organizations.each_with_index do |organization, idx|
          expect(result[idx][:name]).to eq organization.name
          expect(result[idx][:data]).to be_a Hash
        end
      end

      it 'should call the summarization step for each organization' do
        organizations = FactoryBot.create_list(:organization, 10, :with_teams)
        expect(described_class)
          .to receive(:summarize_organization_data)
          .exactly(organizations.length).times
        described_class.overview(bust_cache: true)
      end

      it 'should retrieve the stats of the teams for each team of all organizations' do
        expect(Team.count).to be 0
        return_value = { 'Abc' => { a: 1 } }
        organizations = FactoryBot.create_list(:organization, 10)
        organizations.each do |organization|
          FactoryBot.create(:team, organization: organization)
          FactoryBot.create(:team, organization: organization)
          FactoryBot.create(:team, organization: organization)
        end

        allow_any_instance_of(Team)
          .to receive(:stats)
          .with(any_args)
          .and_return(return_value)
        result = described_class.overview(bust_cache: true)

        expected = { 'Abc' => { a: return_value['Abc'][:a] * organizations.first.teams.length } }
        organizations.each_with_index do |organization, idx|
          expect(result[idx][:name]).to eq organization.name
          expect(result[idx][:data]).to eq expected
        end
      end

      it 'should pass the weeknumber, year and threshold percentage through to the team stats' do
        organization = FactoryBot.create(:organization)
        FactoryBot.create(:team, organization: organization)

        week_number = 12
        year = 12
        threshold_percentage = 42

        expect_any_instance_of(Team)
          .to receive(:stats)
          .with(week_number, year, threshold_percentage)
          .and_call_original

        described_class.overview(week_number: week_number,
                                 year: year,
                                 threshold_percentage: threshold_percentage,
                                 bust_cache: true)
      end
    end
  end

  describe 'self.summarize_organization_data' do
    let(:organization_data) do
      [
        { Person::MENTOR => { completed: 21, missing: 12 },
          Person::STUDENT => { completed: 22, missing: 13 } },
        { Person::MENTOR => { completed: 23, missing: 14 },
          Person::STUDENT => { completed: 24, missing: 15 } },
        { Person::MENTOR => { completed: 25, missing: 16 },
          Person::STUDENT => { completed: 26, missing: 17 } }
      ]
    end

    it 'should return the correct type' do
      result = described_class.summarize_organization_data(organization_data)
      expect(result).to be_a Hash
    end

    it 'should return a hash for all person types' do
      result = described_class.summarize_organization_data(organization_data)
      expect(result).to be_a Hash
      expect(result.keys.length).to eq 2
      expect(result.keys).to match_array [Person::MENTOR, Person::STUDENT]
    end

    it 'should return a hash entry for all stats entries' do
      result = described_class.summarize_organization_data(organization_data)
      [Person::MENTOR, Person::STUDENT].each do |person|
        expect(result[person]).to be_a Hash
        expect(result[person].keys.length).to eq 2
        expect(result[person].keys).to match_array %i[completed missing]
      end
    end

    it 'should sum correctly' do
      result = described_class.summarize_organization_data(organization_data)

      [Person::MENTOR, Person::STUDENT].each do |person|
        %i[completed missing].each do |key|
          sum = organization_data.map { |entry| entry[person][key] }.sum
          expect(result[person][key]).to eq sum
        end
      end
    end

    it 'should not return the percentage_above_threshold attribute' do
      organization_data = [
        { Person::MENTOR => { completed: 21, missing: 12,  percentage_above_threshold: 1 },
          Person::STUDENT => { completed: 22, missing: 13, percentage_above_threshold: 1 } },
        { Person::MENTOR => { completed: 23, missing: 14,  percentage_above_threshold: 1 },
          Person::STUDENT => { completed: 24, missing: 15, percentage_above_threshold: 1 } },
        { Person::MENTOR => { completed: 25, missing: 16,  percentage_above_threshold: 1 },
          Person::STUDENT => { completed: 26, missing: 17, percentage_above_threshold: 1 } }
      ]
      result = described_class.summarize_organization_data(organization_data)
      [Person::MENTOR, Person::STUDENT].each do |person|
        expect(result[person].keys).to match_array %i[completed missing]
        expect(result[person].keys).to_not include :percentage_above_threshold
      end
    end
  end
end
