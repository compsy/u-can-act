# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::RoleController, type: :controller do
  let(:team) { FactoryBot.create(:team) }
  let(:mentor_role) { FactoryBot.create(:role, :mentor, team: team) }
  let(:person) { FactoryBot.create(:person, :with_iban, role: mentor_role, email: 'test@test2.com') }
  let(:params) { {} }

  describe 'without authentication' do
    it 'should head 401' do
      get :index
      expect(response.status).to eq 401
    end
  end

  describe 'with authentication' do
    describe 'index' do
      before :each do
        cookie_auth(person)
      end

      it 'should head 200' do
        get :index
        expect(response.status).to eq 200
      end

      it 'should head a 403 if the current person is not a mentor' do
        student = FactoryBot.create(:student)
        cookie_auth(student)
        get :index
        expect(response.status).to eq 403
      end

      it 'should list an empty array if no roles are available' do
        get :index
        result = JSON.parse(response.body)
        expect(result).to be_an Array
        expect(result).to be_blank
      end

      it 'should only list the available roles' do
        roles = FactoryBot.create_list(:role, 10, team: team)
        FactoryBot.create_list(:role, 10)
        get :index
        result = JSON.parse(response.body)
        expect(result).to be_an Array
        expect(result).to_not be_blank
        expect(result.length).to eq 10
        result.each_with_index do |res, idx|
          expect(res['title']).to eq roles[idx].title
        end
      end

      it 'should use the correct serializer' do
        roles = FactoryBot.create_list(:role, 10, team: team)
        expect(controller).to receive(:render)
          .with(json: roles, each_serializer: Api::RoleSerializer)
          .and_call_original
        get :index
      end
    end
  end
end
