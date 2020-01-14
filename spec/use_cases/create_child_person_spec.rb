# frozen_string_literal: true

require 'rails_helper'

describe CreateChildPerson do
  let!(:parent) { FactoryBot.create(:person) }
  let(:email) { 'test@example.com' }
  let(:team) { FactoryBot.create(:team, :with_roles) }
  let(:team_name) { team.name }
  let(:role) { 'Studenttitle' }
  let(:first_name) { 'Voorneem' }

  it 'creates a new person' do
    expect do
      described_class.run!(parent: parent,
                           email: email,
                           team_name: team_name,
                           first_name: first_name,
                           role_title: role)
    end.to change(Person, :count).by(1)
    person = Person.last
    expect(person.email).to eq email
    expect(person.role.team.name).to eq team_name
    expect(person.role.title).to eq role
    expect(person.first_name).to eq first_name
    expect(person.parent).to eq parent
    # When a parent registers an account for a child, it is not yet activated.
    expect(person.account_active).to be_falsey
  end

  it 'raises an error when the specified role was not found' do
    expect do
      described_class.run!(parent: parent,
                           email: email,
                           team_name: team_name,
                           first_name: first_name,
                           role_title: 'not-a-role')
    end.to raise_error(RuntimeError, "Specified role 'not-a-role' not found in team #{team_name}")
  end

  it 'raises an error when the specified team was not found' do
    expect do
      described_class.run!(parent: parent,
                           email: email,
                           team_name: 'not-a-team',
                           first_name: first_name,
                           role_title: role)
    end.to raise_error(RuntimeError, "Team 'not-a-team' not found")
  end
end
