# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      role = FactoryBot.create(:role)
      expect(role).to be_valid
    end

    describe 'group' do
      it 'should be invalid when not present' do
        role = FactoryBot.build(:role, group: nil)
        expect(role).to_not be_valid
        role = FactoryBot.build(:role, group: Person::STUDENT)
        expect(role).to be_valid
      end

      it 'should be invalid when not in [student or mentor]' do
        role = FactoryBot.build(:role, group: 'bla')
        expect(role).to_not be_valid
        role = FactoryBot.build(:role, group: 'NOTVALID')
        expect(role).to_not be_valid
        role = FactoryBot.build(:role, group: 'Person')
        expect(role).to_not be_valid
      end

      it 'should be valid when not unique in organization if the title is different' do
        role = FactoryBot.create(:role, group: Person::STUDENT, title: 'a')
        role2 = FactoryBot.build(:role, group: Person::STUDENT, title: 'b', organization: role.organization)
        expect(role2).to be_valid
      end

      it 'should be valid when not unique but in different organization' do
        FactoryBot.create(:role, group: Person::MENTOR)
        role2 = FactoryBot.build(:role, group: Person::MENTOR)
        expect(role2).to be_valid
      end
    end

    describe 'title' do
      it 'should be invalid when not present' do
        role = FactoryBot.build(:role, title: nil)
        expect(role).to_not be_valid
        role = FactoryBot.build(:role, title: 'test title')
        expect(role).to be_valid
      end

      it 'should be invalid when not unique in organization' do
        role = FactoryBot.create(:role, title: 'test')
        role2 = FactoryBot.build(:role, title: 'test', organization: role.organization)
        expect(role2).to_not be_valid
      end

      it 'should be valid when not unique but in different organization' do
        FactoryBot.create(:role, title: 'test')
        role2 = FactoryBot.build(:role, title: 'test')
        expect(role2).to be_valid
      end
    end

    describe 'organization_id' do
      it 'should be invalid when not present' do
        organization = FactoryBot.create(:organization)
        role1 = FactoryBot.build(:role, organization_id: nil)
        role2 = FactoryBot.build(:role, organization: organization)

        expect(role1).to_not be_valid
        expect(role2).to be_valid
      end
    end
  end

  it 'should be able to retrieve an organization' do
    role = FactoryBot.create(:role)
    expect(role.organization).to be_a(Organization)
  end

  describe 'stats' do
    it 'should return a hash with the correct keys' do
      role = FactoryBot.create(:role)
      result = role.stats(5, 2017, 50)
      expect(result).to be_a Hash
      expect(result.keys).to eq %i[met_threshold_completion completed total]
    end

    it 'should calculate the correct stats' do
      role = FactoryBot.create(:role)
      year = 2017
      week_number = 5
      threshold_percentage = 50

      people = FactoryBot.create_list(:person, 3)
      people.each_with_index do |person, index|
        mock_stats = {
          met_threshold_completion: index,
          completed: index,
          total: index
        }
        expect(person).to receive(:stats)
          .with(week_number, year, threshold_percentage)
          .and_return(mock_stats)
      end

      role.people << people
      result = role.stats(week_number, year, threshold_percentage)
      expect(result[:met_threshold_completion]).to eq 0 + 1 + 2
      expect(result[:completed]).to eq 0 + 1 + 2
      expect(result[:total]).to eq 0 + 1 + 2
    end

    it 'should return only zeros if there are no subscriptions' do
      role = FactoryBot.create(:role)
      result = role.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 0
      expect(result[:completed]).to eq 0
      expect(result[:total]).to eq 0
    end
  end
end
