# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::PeopleController, type: :controller do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }

  let!(:the_payload) do
    { ENV['SITE_LOCATION'] => {} }
  end

  describe 'unauthorized' do
    let(:email) { 'test@example.com' }
    let(:team) { FactoryBot.create(:team, :with_roles) }
    let(:team_name) { team.name }
    let(:role) { 'Studenttitle' }
    let(:first_name) { 'Voorneem' }
    let(:the_params) { { email: email, team: team_name, role: role, first_name: first_name } }

    it_behaves_like 'a jwt authenticated route', 'post', :create
  end

  describe 'authorized' do
    before do
      the_payload[:sub] = the_auth_user.auth0_id_string
      jwt_auth the_payload
    end

    describe 'create' do
      let(:email) { 'test@example.com' }
      let(:team) { FactoryBot.create(:team, :with_roles) }
      let(:team_name) { team.name }
      let(:role) { 'Studenttitle' }
      let(:first_name) { 'Voorneem' }

      before do
        @old_value = Delayed::Worker.delay_jobs
        Delayed::Worker.delay_jobs = false
      end

      after do
        Delayed::Worker.delay_jobs = @old_value
      end

      it 'returns 200' do
        expect do
          post :create, params: { email: email, team: team_name, role: role, first_name: first_name }
        end.to change(Person, :count).by(1)
        expect(response.status).to be 200
        expect(response.body).to include 'Person created'
        person = Person.last
        expect(person.email).to eq email
        expect(person.role.team.name).to eq team_name
        expect(person.role.title).to eq role
        expect(person.first_name).to eq first_name
        expect(person.parent).to eq the_auth_user.person
      end

      it 'requires an email address' do
        post :create, params: { team: team_name, role: role, first_name: first_name }
        expect(response.status).to eq 400
        expect(response.body).to include 'Email address for creating a person was not specified'
      end

      it 'requires an email address that does not already belong to a person' do
        FactoryBot.create(:person, email: 'hoi@doei.com')
        post :create, params: { email: 'hoi@doei.com', team: team_name, role: role, first_name: first_name }
        expect(response.status).to eq 400
        expect(response.body).to include 'A person already exists with the specified email address'
      end

      it 'requires a team' do
        post :create, params: { email: email, role: role, first_name: first_name }
        expect(response.status).to eq 400
        expect(response.body).to include 'Team for creating a person was not specified'
      end

      it 'requires a role' do
        post :create, params: { email: email, team: team_name, first_name: first_name }
        expect(response.status).to eq 400
        expect(response.body).to include 'Role for creating a person was not specified'
      end

      it 'requires a first_name' do
        post :create, params: { email: email, team: team_name, role: role }
        expect(response.status).to eq 400
        expect(response.body).to include 'First name for creating a person was not specified'
      end
    end

    describe 'list_children' do
      it 'returns a list of children' do
        person = FactoryBot.create(:person, parent: the_auth_user.person)
        get :list_children
        expect(response.status).to eq 200
        result = JSON.parse(response.body)
        expect(result.length).to eq(1)
        expect(result[0]['id']).to eq person.id
        expect(result[0]['first_name']).to eq person.first_name
      end

      it 'works when there are no children' do
        get :list_children
        expect(response.status).to eq 200
        result = JSON.parse(response.body)
        expect(result.length).to eq(0)
      end
    end

    describe 'update_child' do
      # TODO: write specs for update_child
    end

    describe 'destroy_child' do
      # TODO: write specs for destroy_child
    end
  end
end
