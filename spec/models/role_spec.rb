# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  describe 'validations' do
    it 'is valid by default' do
      role = FactoryBot.create(:role)
      expect(role).to be_valid
    end

    describe 'group' do
      it 'is invalid when not present' do
        role = FactoryBot.create(:role)
        role.group = nil
        expect(role).not_to be_valid
        role = FactoryBot.create(:role, group: Person::STUDENT)
        expect(role).to be_valid
      end

      it 'is invalid when not in [student or mentor]' do
        role = FactoryBot.create(:role)
        role.group = 'bla'
        expect(role).not_to be_valid
        role = FactoryBot.create(:role)
        role.group = 'NOTVALID'
        expect(role).not_to be_valid
        role = FactoryBot.create(:role)
        role.group = 'Person'
        expect(role).not_to be_valid
      end

      it 'is valid when not unique in team if the title is different' do
        role = FactoryBot.create(:role, group: Person::STUDENT, title: 'a')
        role2 = FactoryBot.create(:role, group: Person::STUDENT, title: 'b', team: role.team)
        expect(role2).to be_valid
      end

      it 'is valid when not unique but in different team' do
        FactoryBot.create(:role, group: Person::MENTOR)
        role2 = FactoryBot.create(:role, group: Person::MENTOR)
        expect(role2).to be_valid
      end

      it 'accepts SOLO as a valid group' do
        role = FactoryBot.create(:role, group: Person::SOLO)
        expect(role).to be_valid
      end
    end

    describe 'title' do
      it 'is invalid when not present' do
        role = FactoryBot.create(:role)
        role.title = nil
        expect(role).not_to be_valid
        role = FactoryBot.create(:role, title: 'test title')
        expect(role).to be_valid
      end

      it 'is invalid when not unique in team' do
        role = FactoryBot.create(:role, title: 'test')
        role2 = FactoryBot.create(:role, title: 'test')
        role2.team = role.team
        expect(role2).not_to be_valid
      end

      it 'is valid when not unique but in different team' do
        FactoryBot.create(:role, title: 'test')
        role2 = FactoryBot.create(:role, title: 'test')
        expect(role2).to be_valid
      end
    end

    describe 'team_id' do
      it 'is invalid when not present' do
        team = FactoryBot.create(:team)
        role1 = FactoryBot.create(:role)
        role1.team_id = nil
        role2 = FactoryBot.create(:role, team: team)

        expect(role1).not_to be_valid
        expect(role2).to be_valid
      end
    end
  end

  it 'is able to retrieve an team' do
    role = FactoryBot.create(:role)
    expect(role.team).to be_a Team
  end

  describe 'stats' do
    it 'returns a hash with the correct keys' do
      role = FactoryBot.create(:role)
      result = role.stats(5, 2017, 50)
      expect(result).to be_a Hash
      expect(result.keys).to eq %i[met_threshold_completion completed total]
    end

    it 'calculates the correct stats' do
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

    it 'returns only zeros if there are no subscriptions' do
      role = FactoryBot.create(:role)
      result = role.stats(5, 2017, 50)
      expect(result[:met_threshold_completion]).to eq 0
      expect(result[:completed]).to eq 0
      expect(result[:total]).to eq 0
    end
  end
end
