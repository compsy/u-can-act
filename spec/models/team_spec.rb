# frozen_string_literal: true

require 'rails_helper'

describe Team, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      team = FactoryBot.create(:team)
      expect(team).to be_valid
    end

    context 'name' do
      it 'should be invalid when not present' do
        team = FactoryBot.build(:team, name: nil)
        expect(team).to_not be_valid
        team = FactoryBot.build(:team, name: 'test name')
        expect(team).to be_valid
      end

      it 'should be invalid when not unique' do
        FactoryBot.create(:team, name: 'test')
        team2 = FactoryBot.build(:team, name: 'test')
        expect(team2).to_not be_valid
      end
    end

    context 'organization' do
      it 'require an organization' do
        team = FactoryBot.build(:team, organization: nil)
        expect(team).to_not be_valid
        team.organization = FactoryBot.create(:organization)
        expect(team).to be_valid
      end
    end
  end

  it 'should be able to retrieve roles' do
    team = FactoryBot.create(:team, :with_roles)
    expect(team.roles.to_a).to be_a(Array)
    team.roles.each do |role|
      expect(role).to be_a(Role)
    end
  end

  describe 'overview' do
    before :each do
      Timecop.freeze(2017, 5, 5)
    end

    after :each do
      Timecop.return
    end

    context 'without subscriptions and people' do
      it 'should return an empty array if no teams exist' do
        overview = described_class.overview
        expect(overview).to_not be_nil
        expect(overview).to be_a Array
        expect(overview).to eq []
        expect(overview.length).to eq 0
      end

      it 'should return empty hashes if only teams exist' do
        org1 = FactoryBot.create(:team, name: 'org1')
        org2 = FactoryBot.create(:team, name: 'org2')

        overview = described_class.overview
        expect(overview).to_not be_nil
        expect(overview).to be_a Array
        expect(overview.length).to eq 2
        expect(overview.first[:name]).to eq org1.name
        expect(overview.second[:name]).to eq org2.name

        expect(overview.first[:data]).to be_a Hash
        expect(overview.first[:data]).to be_blank
        expect(overview.second[:data]).to be_a Hash
        expect(overview.second[:data]).to be_blank
      end

      it 'should return the correct entries for the roles, even if they are empty' do
        org1 = FactoryBot.create(:team, name: 'org1')
        FactoryBot.create(:role, team: org1, group: Person::STUDENT, title: 'Student')
        FactoryBot.create(:role, team: org1, group: Person::MENTOR, title: 'Mentor')

        overview = described_class.overview
        expect(overview.first[:data]).to be_a Hash
        expect(overview.first[:data].keys.length).to eq 2

        # They should only contain 0 entries
        %w[Student Mentor].each do |group|
          expect(overview.first[:data][group]).to be_a Hash
          expect(overview.first[:data][group]).to_not be_blank
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
                          open_from: Time.zone.now - 10.minutes,
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
                          open_from: Time.zone.now - 1.day,
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
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor2.protocol_subscriptions.first)
      end

      let!(:response11) do
        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now,
                          protocol_subscription: mentor3.protocol_subscriptions.first)
      end

      let!(:response12) do
        FactoryBot.create(:response,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)
      end

      let(:overview) { described_class.overview }
      it 'should generate an overview for all teams in the db' do
        expect(overview).to_not be_nil
        expect(overview).to be_a Array
        expect(overview.length).to eq 2
        expect(overview.first[:name]).to eq org1.name
        expect(overview.second[:name]).to eq org2.name
      end

      it 'should list all role groups' do
        result = overview.first[:data]
        expect(result).to be_a Hash
        expect(result.length).to eq 2
        expect(result.keys).to match_array [Person::STUDENT, Person::MENTOR]
      end

      it 'should list the completed measurements and total measurements for mentors' do
        result = overview.first[:data][Person::MENTOR]
        expect(result).to be_a Hash
        expect(result.length).to eq 4
        expect(result.keys).to match_array %i[completed total met_threshold_completion percentage_above_threshold]
        expect(result[:completed]).to eq 2
        expect(result[:total]).to eq 3
        expect(result[:met_threshold_completion]).to eq 0
        expect(result[:percentage_above_threshold]).to eq 0
      end

      it 'should correctly combine the correct roles for the mentors (it should sum the mentor group)' do
        result = overview.second[:data][Person::MENTOR]
        expect(result).to be_a Hash
        expect(result.length).to eq 4
        expect(result.keys).to match_array %i[completed total met_threshold_completion percentage_above_threshold]
        expect(result[:completed]).to eq 2
        expect(result[:total]).to eq 4
        expect(result[:met_threshold_completion]).to eq 0
        expect(result[:percentage_above_threshold]).to eq 0
      end

      it 'should list the correct threshold completion based on the provided threshold' do
        mentor4 = FactoryBot.create(:person, :with_protocol_subscriptions, role: role5)
        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)

        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)

        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor4.protocol_subscriptions.first)

        result = described_class.overview(nil, nil, 50).second[:data][Person::MENTOR]
        # Three mentors should have achieved the 50%
        expect(result[:met_threshold_completion]).to eq 3
        expect(result[:percentage_above_threshold]).to eq 100

        result = described_class.overview(nil, nil, 75).second[:data][Person::MENTOR]
        # Two mentors should have achieved the 75%
        expect(result[:met_threshold_completion]).to eq 2
        expected = (2.0 / 3.0 * 100).round
        expect(result[:percentage_above_threshold]).to eq expected

        result = described_class.overview(nil, nil, 100).second[:data][Person::MENTOR]
        # Only one should have the 100%
        expect(result[:met_threshold_completion]).to eq 1
        expected = (1.0 / 3.0 * 100).round
        expect(result[:percentage_above_threshold]).to eq expected
      end

      it 'should list the correct threshold completion based on the default threshold' do
        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)

        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)

        expect(Person::DEFAULT_PERCENTAGE).to_not be_nil
        expect(Person::DEFAULT_PERCENTAGE).to be > 0
        result = described_class.overview.second[:data][Person::MENTOR]
        result_with_params = described_class.overview(nil,
                                                      nil,
                                                      Person::DEFAULT_PERCENTAGE)
                                            .second[:data][Person::MENTOR]
        expect(result[:met_threshold_completion]).to eq result_with_params[:met_threshold_completion]
        expect(result[:met_threshold_completion]).to eq 1

        # One out of 2 mentors should have made it, hence 50%
        expect(result[:percentage_above_threshold]).to eq 1.0 / 2.0 * 100
      end

      it 'should list the completed measurements and total measurements for students' do
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
