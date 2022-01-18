# frozen_string_literal: true

require 'rails_helper'

describe Team, type: :model do
  describe 'validations' do
    it 'is valid by default' do
      team = FactoryBot.create(:team)
      expect(team).to be_valid
    end

    context 'name' do
      it 'is invalid when not present' do
        team = FactoryBot.create(:team)
        team.name = nil
        expect(team).not_to be_valid
        team = FactoryBot.create(:team, name: 'test name')
        expect(team).to be_valid
      end

      it 'is invalid when not unique' do
        FactoryBot.create(:team, name: 'test')
        team2 = FactoryBot.create(:team)
        team2.name = 'test'
        expect(team2).not_to be_valid
      end
    end

    context 'organization' do
      it 'require an organization' do
        team = FactoryBot.create(:team)
        team.organization = nil
        expect(team).not_to be_valid
        team.organization = FactoryBot.create(:organization)
        expect(team).to be_valid
      end
    end
  end

  it 'is able to retrieve roles' do
    team = FactoryBot.create(:team, :with_roles)
    expect(team.roles.to_a).to be_a(Array)
    team.roles.each do |role|
      expect(role).to be_a(Role)
    end
  end

  describe 'overview_key' do
    before do
      Timecop.freeze(2017, 5, 5)
    end

    it 'returns a key based on the current week and year if no week or year is provided' do
      result = described_class.overview_key
      year = 2017
      week_number = 18
      expected = "#{described_class::TEAM_OVERVIEW_BASE_KEY}_#{year}_#{week_number}"
      expect(result).to eq expected
    end

    it 'returns a key with the provided week and year' do
      year = 2013
      week_number = 10
      result = described_class.overview_key(week_number, year)
      expected = "#{described_class::TEAM_OVERVIEW_BASE_KEY}_#{year}_#{week_number}"
      expect(result).to eq expected
    end
  end

  describe 'overview' do
    describe 'with the caching function' do
      it 'calls the cacher with the correct parameters' do
        key = described_class.overview_key
        bust_cache = true
        expect(RedisCachedCall).to receive(:cache).with(key, bust_cache) do |&block|
          expect(block).not_to be_nil
        end
        described_class.overview(bust_cache: bust_cache)
      end
      it 'by default it should call the method with bust cache is false' do
        key = described_class.overview_key
        bust_cache = false
        expect(RedisCachedCall).to receive(:cache).with(key, bust_cache) do |&block|
          expect(block).not_to be_nil
        end
        described_class.overview
      end
    end

    describe 'without caching' do
      before do
        Timecop.freeze(2017, 5, 5)
        allow(RedisCachedCall).to receive(:cache).with(any_args).and_yield
      end

      after do
        Timecop.return
      end

      context 'without subscriptions and people' do
        it 'returns an empty array if no teams exist' do
          overview = described_class.overview
          expect(overview).not_to be_nil
          expect(overview).to be_a Array
          expect(overview).to eq []
          expect(overview.length).to eq 0
        end

        it 'returns empty hashes if only teams exist' do
          org1 = FactoryBot.create(:team, name: 'org1')
          org2 = FactoryBot.create(:team, name: 'org2')

          overview = described_class.overview
          expect(overview).not_to be_nil
          expect(overview).to be_a Array
          expect(overview.length).to eq 2
          expect(overview.first[:name]).to eq org1.name
          expect(overview.second[:name]).to eq org2.name

          expect(overview.first[:data]).to be_a Hash
          expect(overview.first[:data]).to be_blank
          expect(overview.second[:data]).to be_a Hash
          expect(overview.second[:data]).to be_blank
        end

        it 'returns the correct entries for the roles, even if they are empty' do
          org1 = FactoryBot.create(:team, name: 'org1')
          FactoryBot.create(:role, team: org1, group: Person::STUDENT, title: 'Student')
          FactoryBot.create(:role, team: org1, group: Person::MENTOR, title: 'Mentor')

          overview = described_class.overview
          expect(overview.first[:data]).to be_a Hash
          expect(overview.first[:data].keys.length).to eq 2

          # They should only contain 0 entries
          %w[Student Mentor].each do |group|
            expect(overview.first[:data][group]).to be_a Hash
            expect(overview.first[:data][group]).not_to be_blank
            overview.first[:data][group].each_value do |val|
              expect(val).to eq 0
            end
          end
        end
      end

      context 'with subscriptions and people' do
        let!(:org1) { FactoryBot.create(:team, name: 'org1') }
        let!(:org2) { FactoryBot.create(:team, name: 'org2') }

        let!(:role1) {  FactoryBot.create(:role, team: org1, group: Person::STUDENT, title: 'Student') }
        let!(:role2) {  FactoryBot.create(:role, team: org1, group: Person::MENTOR, title: 'Mentor') }

        let!(:role3) {  FactoryBot.create(:role, team: org2, group: Person::STUDENT, title: 'Student') }
        let!(:role4) {  FactoryBot.create(:role, team: org2, group: Person::MENTOR, title: 'Mentor') }
        let!(:role5) {  FactoryBot.create(:role, team: org2, group: Person::MENTOR, title: 'S-Teamer') }

        let!(:student1) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role1) }
        let!(:student2) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role1) }
        let!(:mentor1) { FactoryBot.create(:person, :with_protocol_subscriptions, role: role2) }

        let!(:student3) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role3) }
        let!(:student4) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role3) }
        let!(:mentor2) { FactoryBot.create(:person, :with_protocol_subscriptions, role: role4) }
        let!(:mentor3) { FactoryBot.create(:person, :with_protocol_subscriptions, role: role5) }

        let!(:response1) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: student1.protocol_subscriptions.first)
        end
        let!(:response2) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: student2.protocol_subscriptions.first)
        end
        let!(:response3) do
          FactoryBot.create(:response,
                            protocol_subscription: student1.protocol_subscriptions.first)
        end
        let!(:response4) do
          FactoryBot.create(:response,
                            open_from: 10.minutes.ago,
                            protocol_subscription: student2.protocol_subscriptions.first)
        end

        let!(:response5) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: mentor1.protocol_subscriptions.first)
        end
        let!(:response6) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: mentor1.protocol_subscriptions.first)
        end
        let!(:response7) do
          FactoryBot.create(:response,
                            open_from: 1.day.ago,
                            protocol_subscription: mentor1.protocol_subscriptions.first)
        end
        let!(:response8) do
          FactoryBot.create(:response,
                            protocol_subscription: mentor1.protocol_subscriptions.first)
        end

        let!(:response9) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: mentor2.protocol_subscriptions.first)
        end

        let!(:response10) do
          FactoryBot.create(:response,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor2.protocol_subscriptions.first)
        end

        let!(:response11) do
          FactoryBot.create(:response, :completed,
                            open_from: Time.zone.now,
                            protocol_subscription: mentor3.protocol_subscriptions.first)
        end

        let!(:response12) do
          FactoryBot.create(:response,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor3.protocol_subscriptions.first)
        end

        let(:overview) { described_class.overview }

        it 'generates an overview for all teams in the db' do
          expect(overview).not_to be_nil
          expect(overview).to be_a Array
          expect(overview.length).to eq 2
          expect(overview.first[:name]).to eq org1.name
          expect(overview.second[:name]).to eq org2.name
        end

        it 'lists all role groups' do
          result = overview.first[:data]
          expect(result).to be_a Hash
          expect(result.length).to eq 2
          expect(result.keys).to match_array [Person::STUDENT, Person::MENTOR]
        end

        it 'lists the completed measurements and total measurements for mentors' do
          result = overview.first[:data][Person::MENTOR]
          expect(result).to be_a Hash
          expect(result.length).to eq 4
          expect(result.keys).to match_array %i[completed total met_threshold_completion percentage_above_threshold]
          expect(result[:completed]).to eq 2
          expect(result[:total]).to eq 3
          expect(result[:met_threshold_completion]).to eq 0
          expect(result[:percentage_above_threshold]).to eq 0
        end

        it 'correctlies combine the correct roles for the mentors (it should sum the mentor group)' do
          result = overview.second[:data][Person::MENTOR]
          expect(result).to be_a Hash
          expect(result.length).to eq 4
          expect(result.keys).to match_array %i[completed total met_threshold_completion percentage_above_threshold]
          expect(result[:completed]).to eq 2
          expect(result[:total]).to eq 4
          expect(result[:met_threshold_completion]).to eq 0
          expect(result[:percentage_above_threshold]).to eq 0
        end

        it 'lists the correct threshold completion based on the provided threshold' do
          mentor4 = FactoryBot.create(:person, :with_protocol_subscriptions, role: role5)
          FactoryBot.create(:response, :completed,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor3.protocol_subscriptions.first)

          FactoryBot.create(:response, :completed,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor3.protocol_subscriptions.first)

          FactoryBot.create(:response, :completed,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor4.protocol_subscriptions.first)

          result = described_class.overview(week_number: nil,
                                            year: nil,
                                            threshold_percentage: 50).second[:data][Person::MENTOR]
          # Three mentors should have achieved the 50%
          expect(result[:met_threshold_completion]).to eq 3
          expect(result[:percentage_above_threshold]).to eq 100

          result = described_class.overview(week_number: nil,
                                            year: nil,
                                            threshold_percentage: 75).second[:data][Person::MENTOR]
          # Two mentors should have achieved the 75%
          expect(result[:met_threshold_completion]).to eq 2
          expected = (2.0 / 3.0 * 100).round
          expect(result[:percentage_above_threshold]).to eq expected

          result = described_class.overview(week_number: nil,
                                            year: nil,
                                            threshold_percentage: 100).second[:data][Person::MENTOR]
          # Only one should have the 100%
          expect(result[:met_threshold_completion]).to eq 1
          expected = (1.0 / 3.0 * 100).round
          expect(result[:percentage_above_threshold]).to eq expected
        end

        it 'lists the correct threshold completion based on the default threshold' do
          FactoryBot.create(:response, :completed,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor3.protocol_subscriptions.first)

          FactoryBot.create(:response, :completed,
                            open_from: 10.minutes.ago,
                            protocol_subscription: mentor3.protocol_subscriptions.first)

          expect(Person::DEFAULT_PERCENTAGE).not_to be_nil
          expect(Person::DEFAULT_PERCENTAGE).to be > 0
          result = described_class.overview.second[:data][Person::MENTOR]
          result_with_params = described_class.overview(week_number: nil,
                                                        year: nil,
                                                        threshold_percentage: Person::DEFAULT_PERCENTAGE)
                                              .second[:data][Person::MENTOR]
          expect(result[:met_threshold_completion]).to eq result_with_params[:met_threshold_completion]
          expect(result[:met_threshold_completion]).to eq 1

          # One out of 2 mentors should have made it, hence 50%
          expect(result[:percentage_above_threshold]).to eq 1.0 / 2.0 * 100
        end

        it 'lists the completed measurements and total measurements for students' do
          result = overview.first[:data][Person::STUDENT]
          expect(result).to be_a Hash
          expect(result.length).to eq 4
          expect(result.keys).to match_array %i[completed total met_threshold_completion percentage_above_threshold]
          expect(result[:completed]).to eq 2
          expect(result[:total]).to eq 3

          # one of the students actually had 100% completion, this week, as it
          # had only one response
          expect(result[:met_threshold_completion]).to eq 1

          # 1 out of two students
          expect(result[:percentage_above_threshold]).to eq 1.0 / 2.0 * 100
        end
      end
    end
  end
end
