# frozen_string_literal: true

require 'rails_helper'

describe Organization, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      organization = FactoryGirl.create(:organization)
      expect(organization).to be_valid
    end

    describe 'name' do
      it 'should be invalid when not present' do
        organization = FactoryGirl.build(:organization, name: nil)
        expect(organization).to_not be_valid
        organization = FactoryGirl.build(:organization, name: 'test name')
        expect(organization).to be_valid
      end

      it 'should be invalid when not unique' do
        FactoryGirl.create(:organization, name: 'test')
        organization2 = FactoryGirl.build(:organization, name: 'test')
        expect(organization2).to_not be_valid
      end
    end
  end

  it 'should be able to retrieve roles' do
    organization = FactoryGirl.create(:organization, :with_roles)
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

    let!(:org1) { FactoryGirl.create(:organization, name: 'org1') }
    let!(:org2) { FactoryGirl.create(:organization, name: 'org2') }

    let!(:role1) {  FactoryGirl.create(:role, organization: org1, group: Person::STUDENT, title: 'Student') }
    let!(:role2) {  FactoryGirl.create(:role, organization: org1, group: Person::MENTOR, title: 'Mentor') }

    let!(:role3) {  FactoryGirl.create(:role, organization: org2, group: Person::STUDENT, title: 'Student') }
    let!(:role4) {  FactoryGirl.create(:role, organization: org2, group: Person::MENTOR, title: 'Mentor') }

    let!(:student1) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:student2) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:mentor1) { FactoryGirl.create(:person, :with_protocol_subscriptions, role: role2) }

    let!(:student3) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role3) }
    let!(:student4) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role3) }
    let!(:mentor2) { FactoryGirl.create(:person, :with_protocol_subscriptions, role: role4) }

    let!(:response1) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response2) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: student2.protocol_subscriptions.first)
    end
    let!(:response3) do
      FactoryGirl.create(:response,
                         protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response4) do
      FactoryGirl.create(:response,
                         open_from: Time.zone.now + 1.day,
                         protocol_subscription: student2.protocol_subscriptions.first)
    end

    let!(:response5) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response6) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response7) do
      FactoryGirl.create(:response,
                         open_from: Time.zone.now + 1.day,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response8) do
      FactoryGirl.create(:response,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end

    it 'should generate an overview for all organizations in the db' do
      result = described_class.organization_overview
      expect(result).to_not be_nil
      expect(result).to be_a Array
      expect(result.length).to eq 2
      expect(result.first[:name]).to eq org1.name
      expect(result.second[:name]).to eq org2.name
    end

    it 'should list all role titles' do
      result = described_class.organization_overview.first[:data]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match_array [Person::STUDENT, Person::MENTOR]
    end

    it 'should list the completed measurements and total measurements for mentors' do
      result = described_class.organization_overview.first[:data][Person::MENTOR]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match %i[completed total]
      expect(result[:completed]).to eq 2
      expect(result[:total]).to eq 3
    end

    it 'should list the completed measurements and total measurements for students' do
      result = described_class.organization_overview.first[:data][Person::STUDENT]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match %i[completed total]
      expect(result[:completed]).to eq 2
      expect(result[:total]).to eq 3
    end
  end
end
