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
end
