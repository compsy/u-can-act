# frozen_string_literal: true

require 'rails_helper'

describe CreateAnonymousUser do
  describe 'with a role_title specified' do
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Teamname') }
    let(:auth0_id_string) { 'hoi' }
    let(:role_title) { 'Studenttitle' }
    let(:email) { 'test@example.com' }
    let(:access_level) { AuthUser::USER_ACCESS_LEVEL }

    it 'creates a new auth user and person with the correct properties' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user = described_class.run!(auth0_id_string: auth0_id_string,
                                       team_name: team.name,
                                       role_title: role_title,
                                       email: email,
                                       access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count + 1)
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.email).to be_blank
      expect(auth_user.person.account_active).to be_truthy
    end

    it 'raises an error when the role was not found' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      expect do
        described_class.run!(auth0_id_string: auth0_id_string,
                             team_name: team.name,
                             role_title: 'not-a-role',
                             email: email,
                             access_level: access_level)
      end.to raise_error(RuntimeError, "Specified role 'not-a-role' not found in team #{team.name}")
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count)
    end

    it 'raises an error when a team has no roles' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      team.roles.destroy_all
      expect do
        described_class.run!(auth0_id_string: auth0_id_string,
                             team_name: team.name,
                             role_title: nil,
                             email: email,
                             access_level: access_level)
      end.to raise_error(RuntimeError, "Team '#{team.name}' has no roles")
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count)
    end

    it 'raises an error when team name is not specified' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      team.roles.destroy_all
      expect do
        described_class.run!(auth0_id_string: auth0_id_string,
                             team_name: '',
                             role_title: role_title,
                             email: email,
                             access_level: access_level)
      end.to raise_error(RuntimeError, 'Required payload attribute team not specified')
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count)
    end

    it 'raises an error when the specified team was not found' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      team.roles.destroy_all
      expect do
        described_class.run!(auth0_id_string: auth0_id_string,
                             team_name: 'not-a-team',
                             role_title: role_title,
                             email: email,
                             access_level: access_level)
      end.to raise_error(RuntimeError, "Team 'not-a-team' not found")
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count)
    end

    it 'reuses the existing auth_user and person if they exist' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person,
                                 first_name: auth0_id_string,
                                 last_name: auth0_id_string,
                                 role: role,
                                 account_active: true)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string, person: person)
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        role_title: role_title,
                                        email: email,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.email).to be_blank
      # if an auth_user has a person, it was assumed to be active, so we don't change the property here
      expect(auth_user.person.account_active).to be_truthy
    end

    it 'reuses the existing person with given email' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person,
                                 first_name: 'Some name',
                                 last_name: '2',
                                 role: role,
                                 email: email,
                                 account_active: false)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string)
      expect(person.account_active).to be_falsey
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        role_title: role_title,
                                        email: email,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      auth_user.reload
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq 'Some name'
      expect(auth_user.person.last_name).to eq '2'
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.email).to be_blank
      expect(auth_user.person.account_active).to be_truthy
    end
  end

  describe 'without a role_title specified' do
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Teamname') }
    let(:auth0_id_string) { 'hoi' }
    let(:role_title) { 'Studenttitle' }
    let(:email) { 'test@example.com' }
    let(:access_level) { AuthUser::USER_ACCESS_LEVEL }

    it 'creates a new auth user and person with the correct properties' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user = described_class.run!(auth0_id_string: auth0_id_string,
                                       team_name: team.name,
                                       access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count + 1)
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.email).to be_blank
      expect(auth_user.person.account_active).to be_truthy
    end

    it 'reuses the existing auth_user and person if they exist' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person,
                                 first_name: auth0_id_string,
                                 last_name: auth0_id_string,
                                 role: role,
                                 account_active: true)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string, person: person)
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.account_active).to be_truthy
    end

    it 'reuses the existing auth_user and person if they exist' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person,
                                 first_name: auth0_id_string,
                                 last_name: auth0_id_string,
                                 role: role,
                                 email: email,
                                 account_active: true)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string)
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        email: email,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      auth_user.reload
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
      expect(auth_user.person.account_active).to be_truthy
    end
  end
end
