# frozen_string_literal: true

require 'rails_helper'

describe Organization, type: :model do
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

  it 'should be able to retrieve roles' do
    organization = FactoryBot.create(:organization, :with_roles)
    expect(organization.roles.to_a).to be_a(Array)
    organization.roles.each do |role|
      expect(role).to be_a(Role)
    end
  end

  describe 'organization_overview' do
    before :each do
      Timecop.freeze(2017, 5, 5)
    end

    after :each do
      Timecop.return
    end
    context 'without subscriptions and people' do
      it 'should return an empty array if no organizations exist' do
        overview = described_class.organization_overview
        expect(overview).to_not be_nil
        expect(overview).to be_a Array
        expect(overview).to eq []
        expect(overview.length).to eq 0
      end

      it 'should return empty hashes if only organizations exist' do
        org1 = FactoryBot.create(:organization, name: 'org1')
        org2 = FactoryBot.create(:organization, name: 'org2')

        overview = described_class.organization_overview
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
        org1 = FactoryBot.create(:organization, name: 'org1')
        FactoryBot.create(:role, organization: org1, group: Person::STUDENT, title: 'Student')
        FactoryBot.create(:role, organization: org1, group: Person::MENTOR, title: 'Mentor')

        overview = described_class.organization_overview
        expect(overview.first[:data]).to be_a Hash
        expect(overview.first[:data].keys.length).to eq 2
        expect(overview.first[:data]['Student']).to be_a Hash
        expect(overview.first[:data]['Student']).to be_blank

        expect(overview.first[:data]['Mentor']).to be_a Hash
        expect(overview.first[:data]['Mentor']).to be_blank
      end
    end

    context 'with subscriptions and people' do
      let!(:org1) { FactoryBot.create(:organization, name: 'org1') }
      let!(:org2) { FactoryBot.create(:organization, name: 'org2') }

      let!(:role1) {  FactoryBot.create(:role, organization: org1, group: Person::STUDENT, title: 'Student') }
      let!(:role2) {  FactoryBot.create(:role, organization: org1, group: Person::MENTOR, title: 'Mentor') }

      let!(:role3) {  FactoryBot.create(:role, organization: org2, group: Person::STUDENT, title: 'Student') }
      let!(:role4) {  FactoryBot.create(:role, organization: org2, group: Person::MENTOR, title: 'Mentor') }
      let!(:role5) {  FactoryBot.create(:role, organization: org2, group: Person::MENTOR, title: 'S-Teamer') }

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
                          open_from: Time.zone.now + 1.day,
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
                          open_from: Time.zone.now + 1.day,
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

      let!(:response9) do
        FactoryBot.create(:response,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor2.protocol_subscriptions.first)
      end

      let!(:response10) do
        FactoryBot.create(:response, :completed,
                          open_from: Time.zone.now,
                          protocol_subscription: mentor3.protocol_subscriptions.first)
      end

      let!(:response11) do
        FactoryBot.create(:response,
                          open_from: Time.zone.now - 10.minutes,
                          protocol_subscription: mentor3.protocol_subscriptions.first)
      end

      let(:overview) { described_class.organization_overview }
      it 'should generate an overview for all organizations in the db' do
        expect(overview).to_not be_nil
        expect(overview).to be_a Array
        expect(overview.length).to eq 2
        expect(overview.first[:name]).to eq org1.name
        expect(overview.second[:name]).to eq org2.name
      end

      it 'should list all role titles' do
        result = overview.first[:data]
        expect(result).to be_a Hash
        expect(result.length).to eq 2
        expect(result.keys).to match_array [Person::STUDENT, Person::MENTOR]
      end

      it 'should list the completed measurements and total measurements for mentors' do
        result = overview.first[:data][Person::MENTOR]
        puts result
        expect(result).to be_a Hash
        expect(result.length).to eq 2
        expect(result.keys).to match %i[completed total]
        expect(result[:completed]).to eq 2
        expect(result[:total]).to eq 3
      end

      it 'should correctly combine the correct roles for the mentors (it should sum the mentor group)' do
        result = overview.second[:data][Person::MENTOR]
        expect(result).to be_a Hash
        expect(result.length).to eq 2
        expect(result.keys).to match %i[completed total]
        expect(result[:completed]).to eq 2
        expect(result[:total]).to eq 4
      end

      it 'should list the completed measurements and total measurements for students' do
        result = overview.first[:data][Person::STUDENT]
        expect(result).to be_a Hash
        expect(result.length).to eq 2
        expect(result.keys).to match %i[completed total]
        expect(result[:completed]).to eq 2
        expect(result[:total]).to eq 3
      end
    end
  end
end
