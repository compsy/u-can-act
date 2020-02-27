# frozen_string_literal: true

require 'rails_helper'

describe CreateDummyUser do
  let(:team) { FactoryBot.create(:team, :with_roles) }
  let(:team_name) { team.name }
  let(:role) { FactoryBot.create(:role, team: team) }
  let(:role_title) { role.title }
  let(:role_group) { role.group }
  let(:email) { 'test@example.com' }
  let(:first_name) { 'my-first-name' }
  let(:last_name) { 'my-last-name' }
  let(:auth0_id_string) { 'auth0-id-string' }
  let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
  let(:protocol_name) { protocol.name }

  it 'creates a new person' do
    bef_count = AuthUser.count
    expect do
      described_class.run!(team_name: team_name,
                           role_title: role_title,
                           role_group: role_group,
                           email: email,
                           first_name: first_name,
                           last_name: last_name,
                           auth0_id_string: auth0_id_string,
                           protocol_name: protocol_name)
    end.to change(Person, :count).by(1)
    expect(AuthUser.count).to eq(bef_count + 1)
    person = Person.last
    expect(person.role.team.name).to eq team_name
    expect(person.role.title).to eq role_title
    expect(person.role.group).to eq role_group
    expect(person.email).to eq email
    expect(person.first_name).to eq first_name
    expect(person.last_name).to eq last_name
    expect(person.protocol_subscriptions.first.protocol.name).to eq protocol_name
    expect(person.auth_user.auth0_id_string).to eq auth0_id_string
    expect(person.account_active).to be_truthy
    expect(person.responses.completed.count).to eq protocol.measurements.count
  end

  it 'updates an existing person' do
    # it should destroy responses and remake them, and reuse person and auth_user
    described_class.run!(team_name: team_name,
                         role_title: role_title,
                         role_group: role_group,
                         email: email,
                         first_name: first_name,
                         last_name: last_name,
                         auth0_id_string: auth0_id_string,
                         protocol_name: protocol_name)
    person_id = Person.last.id
    auth_user_id = Person.last.auth_user.id
    response_id = Person.last.responses.first.id
    expect(Person.exists?(person_id)).to be_truthy
    expect(AuthUser.exists?(auth_user_id)).to be_truthy
    expect(Response.exists?(response_id)).to be_truthy
    bef_acount = AuthUser.count
    bef_pcount = Person.count
    bef_rcount = Response.count
    described_class.run!(team_name: team_name,
                         role_title: role_title,
                         role_group: role_group,
                         email: email,
                         first_name: first_name,
                         last_name: last_name,
                         auth0_id_string: auth0_id_string,
                         protocol_name: protocol_name)
    expect(AuthUser.count).to eq bef_acount
    expect(Person.count).to eq bef_pcount
    expect(Response.count).to eq bef_rcount
    expect(Person.exists?(person_id)).to be_truthy
    expect(AuthUser.exists?(auth_user_id)).to be_truthy
    # it should have destroyed all previous responses and made new ones
    expect(Response.exists?(response_id)).to be_falsey
  end

  it 'raises an error when the specified team was not found' do
    expect do
      described_class.run!(team_name: 'not-a-team',
                           role_title: role_title,
                           role_group: role_group,
                           email: email,
                           first_name: first_name,
                           last_name: last_name,
                           auth0_id_string: auth0_id_string,
                           protocol_name: protocol_name)
    end.to raise_error(RuntimeError, "Team 'not-a-team' not found")
  end

  it 'raises an error when the specified role was not found' do
    expect do
      described_class.run!(team_name: team_name,
                           role_title: 'not-a-role-title',
                           role_group: role_group,
                           email: email,
                           first_name: first_name,
                           last_name: last_name,
                           auth0_id_string: auth0_id_string,
                           protocol_name: protocol_name)
    end.to raise_error(RuntimeError, "Role with group '#{role_group}' and title 'not-a-role-title' not found")
    expect do
      described_class.run!(team_name: team_name,
                           role_title: role_title,
                           role_group: 'not-a-role-group',
                           email: email,
                           first_name: first_name,
                           last_name: last_name,
                           auth0_id_string: auth0_id_string,
                           protocol_name: protocol_name)
    end.to raise_error(RuntimeError, "Role with group 'not-a-role-group' and title '#{role_title}' not found")
  end

  it 'raises an error when the specified protocol was not found' do
    expect do
      described_class.run!(team_name: team_name,
                           role_title: role_title,
                           role_group: role_group,
                           email: email,
                           first_name: first_name,
                           last_name: last_name,
                           auth0_id_string: auth0_id_string,
                           protocol_name: 'not-a-protocol')
    end.to raise_error(RuntimeError, "Protocol 'not-a-protocol' not found")
  end
end
