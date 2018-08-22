# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::RoleController, type: :controller do
  let(:team) { FactoryBot.create(:team) }
  let(:mentor_role) { FactoryBot.create(:role, :mentor, team: team) }
  let(:person) { FactoryBot.create(:person, :with_iban, role: mentor_role, email: 'test@test2.com') }

  it_should_behave_like 'an is_logged_in_as_mentor concern', 'get', :index

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
        result = result.map { |res| res['title'] }
        expected = roles.map(&:title)
        expect(result).to match_array(expected)
      end

      it 'should use the correct serializer' do
        roles = FactoryBot.create_list(:role, 10, :student, team: team)
        expect(controller).to receive(:render)
          .with(json: array_including(roles), each_serializer: Api::RoleSerializer)
          .and_call_original
        get :index
      end
    end
  end
end
