# frozen_string_literal: true

require 'rails_helper'

describe CreateAnonymousPerson do
  describe 'with team with roles' do
    let(:team) { FactoryBot.create(:team, :with_roles, name: 'Teamname') }

    it 'creates a new person' do
      pre_count = Person.count
      described_class.run!(team_name: team.name)
      post_count = Person.count
      expect(pre_count + 1).to eq post_count
    end

    it 'initializes it with the correct role' do
      described_class.run!(team_name: team.name)
      person = Person.last
      expect(person.role).to eq team.roles.first
    end

    it 'sets the name of the person to a default' do
      described_class.run!(team_name: team.name)
      person = Person.last
      expect(person.first_name).to eq described_class::DEFAULT_FIRST_NAME
    end
  end

  describe 'with team without roles' do
    let(:team) { FactoryBot.create(:team) }

    it 'raises if a team is provided that does not have roles' do
      expect { described_class.run!(team_name: team.name) }
        .to raise_error RuntimeError, "Team #{team.name} not found or does not have roles!"
    end
  end
end
