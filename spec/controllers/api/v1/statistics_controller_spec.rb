# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::StatisticsController, type: :controller do
  before do
    Timecop.freeze(Date.new(2017, 5, 8))
  end

  let(:org1) { FactoryBot.create(:team) }
  let(:org2) { FactoryBot.create(:team) }
  let(:student_role1) { FactoryBot.create(:role, group: Person::STUDENT, team: org1) }
  let(:student_role2) { FactoryBot.create(:role, group: Person::STUDENT, team: org2) }
  let(:mentor_role1) { FactoryBot.create(:role, group: Person::MENTOR, team: org1) }
  let(:mentor_role2) { FactoryBot.create(:role, group: Person::MENTOR, team: org2) }
  let!(:studs1) { FactoryBot.create_list(:person, 15, role: student_role1) }
  let!(:studs2) { FactoryBot.create_list(:person, 9, role: student_role2) }
  let!(:mentors1) { FactoryBot.create_list(:person, 1, role: mentor_role1) }
  let!(:mentors2) { FactoryBot.create_list(:person, 7, role: mentor_role2) }
  let!(:responses) { FactoryBot.create_list(:response, 7, :completed) }

  describe 'index' do
    it 'renders a json file with the correct entries' do
      expected = %w[number_of_students
                    number_of_mentors
                    duration_of_project_in_weeks
                    number_of_completed_questionnaires
                    number_of_book_signups]
      get :index
      json_response = response.parsed_body
      expect(json_response.keys.length).to eq 5
      expect(json_response.keys).to match_array(expected)
    end

    it 'lists the correct number of students' do
      protocol1 = FactoryBot.create(:protocol, name: 'protocol_one')
      protocol3 = FactoryBot.create(:protocol, name: 'protocol_three')
      studs1.each do |student|
        FactoryBot.create(:protocol_subscription,
                          person: student,
                          protocol: protocol1,
                          informed_consent_given_at: nil)
        FactoryBot.create(:protocol_subscription,
                          person: student,
                          protocol: protocol3,
                          informed_consent_given_at: Time.zone.now)
      end
      protocol2 = FactoryBot.create(:protocol, name: 'protocol_two')
      studs2.each do |student|
        FactoryBot.create(:protocol_subscription,
                          person: student,
                          protocol: protocol2,
                          informed_consent_given_at: Time.zone.now)
      end
      # It should not count loose responses, it should not count protocol subscriptions without
      # an informed consent given.
      expected = studs1.count + studs2.count
      get :index
      json_response = response.parsed_body
      expect(json_response['number_of_students']).to eq expected
    end

    it 'lists the correct number of mentors' do
      protocol3 = FactoryBot.create(:protocol, name: 'protocol_three')
      mentors1.each do |mentor|
        FactoryBot.create(:protocol_subscription,
                          person: mentor,
                          protocol: protocol3,
                          informed_consent_given_at: nil)
        FactoryBot.create(:protocol_subscription,
                          person: mentor,
                          protocol: protocol3,
                          informed_consent_given_at: Time.zone.now)
      end
      protocol2 = FactoryBot.create(:protocol, name: 'protocol_two')
      mentors2.each do |mentor|
        FactoryBot.create(:protocol_subscription,
                          person: mentor,
                          protocol: protocol2,
                          informed_consent_given_at: Time.zone.now)
      end
      # It should not count loose responses, it should not count protocol subscriptions without
      # an informed consent given.
      expected = mentors1.count + mentors2.count
      get :index
      json_response = response.parsed_body
      expect(json_response['number_of_mentors']).to eq expected
    end

    describe 'duration_of_project_in_weeks' do
      it 'returns the correct duration of the project' do
        expect(Rails.application.config.settings).to receive(:project_start_date)
          .once.and_return('2017-03-17')
        expect(Rails.application.config.settings).to receive(:project_end_date)
          .once.and_return('2018-08-06')
        get :index
        json_response = response.parsed_body
        expected = 7 + 1 # we also count the active week
        expect(json_response['duration_of_project_in_weeks']).to eq expected
      end

      it 'returns the correct duration of the project if we are past the end date' do
        expect(Rails.application.config.settings).to receive(:project_start_date)
          .once.and_return('2017-03-17')
        expect(Rails.application.config.settings).to receive(:project_end_date)
          .once.and_return('2017-03-27')
        get :index
        json_response = response.parsed_body
        expected = 2 # we also count the active week
        expect(json_response['duration_of_project_in_weeks']).to eq expected
      end

      it 'returns zero if the start date is after the end date' do
        expect(Rails.application.config.settings).to receive(:project_start_date)
          .once.and_return('2017-03-27')
        expect(Rails.application.config.settings).to receive(:project_end_date)
          .once.and_return('2017-03-17')
        get :index
        json_response = response.parsed_body
        expect(json_response['duration_of_project_in_weeks']).to eq 0
      end
    end

    it 'returns the correct number of completed questionnaires' do
      protocol1 = FactoryBot.create(:protocol, name: 'protocol_one')
      protocol2 = FactoryBot.create(:protocol, name: 'protocol_two')
      protocol3 = FactoryBot.create(:protocol, name: 'protocol_three')
      counted_measurement1 = FactoryBot.create(:measurement, protocol: protocol1)
      counted_measurement2 = FactoryBot.create(:measurement, protocol: protocol2)
      counted_measurement3 = FactoryBot.create(:measurement, protocol: protocol3)
      counted_responses = FactoryBot.create_list(:response, 7, :completed, measurement: counted_measurement1)
      counted_responses += FactoryBot.create_list(:response, 11, :completed, measurement: counted_measurement2)
      counted_responses += FactoryBot.create_list(:response, 13, :completed, measurement: counted_measurement3)
      expected = responses.count + counted_responses.count
      get :index
      json_response = response.parsed_body
      expect(json_response['number_of_completed_questionnaires']).to eq expected
    end

    it 'returns the correct number of book signups' do
      protocol = FactoryBot.create(:protocol, name: 'boek')
      questionnaire = FactoryBot.create(:questionnaire, name: 'boek')
      measurement = FactoryBot.create(:measurement, protocol: protocol, questionnaire: questionnaire)
      responses = FactoryBot.create_list(:response, 7, :completed, measurement: measurement)
      FactoryBot.create_list(:response, 5, measurement: measurement)
      expected = responses.count
      get :index
      json_response = response.parsed_body
      expect(json_response['number_of_book_signups']).to eq expected
    end
  end
end
