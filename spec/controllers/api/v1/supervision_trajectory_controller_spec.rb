# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SupervisionTrajectoryController, type: :controller do
  let(:team) { FactoryBot.create(:team) }
  let(:mentor_role) { FactoryBot.create(:role, :mentor, team: team) }
  let(:person) { FactoryBot.create(:person, :with_iban, role: mentor_role, email: 'test@test2.com') }
  let(:params) { {} }

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

      it 'should list an empty array if no supervisiontrajectories are available' do
        get :index
        result = JSON.parse(response.body)
        expect(result).to be_an Array
        expect(result).to be_blank
      end

      it 'should all supervisiontrajectories' do
        traj = FactoryBot.create_list(:supervision_trajectory, 10)
        get :index
        result = JSON.parse(response.body)
        expect(result).to be_an Array
        expect(result).to_not be_blank
        expect(result.length).to eq 10
        result.each_with_index do |res, idx|
          expect(res['name']).to eq traj[idx].name
        end
      end

      it 'should use the correct serializer' do
        traj = FactoryBot.create_list(:supervision_trajectory, 10)
        expect(controller).to receive(:render)
          .with(json: traj, each_serializer: Api::SupervisionTrajectorySerializer)
          .and_call_original
        get :index
      end
    end
  end
end
