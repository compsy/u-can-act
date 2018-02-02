# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    describe StatisticsController, type: :controller do
      before do
        Timecop.freeze(Date.new(2017, 5, 8))
      end

      let(:org1) { FactoryBot.create(:organization) }
      let(:org2) { FactoryBot.create(:organization) }
      let(:student_role1)  { FactoryBot.create(:role, group: Person::STUDENT, organization: org1) }
      let(:student_role2)  { FactoryBot.create(:role, group: Person::STUDENT, organization: org2) }
      let(:mentor_role1)  { FactoryBot.create(:role, group: Person::MENTOR, organization: org1) }
      let(:mentor_role2)  { FactoryBot.create(:role, group: Person::MENTOR, organization: org2) }
      let!(:studs1) { FactoryBot.create_list(:person, 15, role: student_role1) }
      let!(:studs2) { FactoryBot.create_list(:person, 9, role: student_role2) }
      let!(:mentors1) { FactoryBot.create_list(:person, 1, role: mentor_role1) }
      let!(:mentors2) { FactoryBot.create_list(:person, 7, role: mentor_role2) }
      let!(:responses) { FactoryBot.create_list(:response, 7, :completed) }

      describe 'index' do
        before do
          get :index
          @json_response = JSON.parse(response.body)
        end
        it 'should render a json file with the correct entries' do
          expected = %w[number_of_students
                        number_of_mentors
                        duration_of_project_in_weeks
                        number_of_completed_questionnaires]

          expect(@json_response.keys.length).to eq 4
          expect(@json_response.keys).to match_array(expected)
        end

        it 'should list the correct number of students' do
          # + responses.length because that one also creates students
          expected = studs1.length + studs2.length + responses.length
          expect(@json_response['number_of_students']).to eq expected
        end

        it 'should list the correct number of mentors' do
          expected = mentors1.length + mentors2.length
          expect(@json_response['number_of_mentors']).to eq expected
        end

        it 'should return the correct duration of the project' do
          cached_start = ENV['PROJECT_START_DATE']
          ENV['PROJECT_START_DATE'] = '2017-03-17'
          get :index
          @json_response = JSON.parse(response.body)

          expected = 7 + 1 # we also count the active week
          expect(@json_response['duration_of_project_in_weeks']).to eq expected
          ENV['PROJECT_START_DATE'] = cached_start
        end

        it 'should return the correct number of completed questionnaires' do
          expected = responses.length
          expect(@json_response['number_of_completed_questionnaires']).to eq expected
        end
      end
    end
  end
end
