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
    it 'should render a json file with the correct entries' do
      expected = %w[number_of_students
                    number_of_mentors
                    duration_of_project_in_weeks
                    number_of_completed_questionnaires]
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 4
      expect(json_response.keys).to match_array(expected)
    end

    it 'should list the correct number of students' do
      protocol_names = double('protocol_names')
      expect(protocol_names).to receive(:student).exactly(2).times.and_return(%w[protocol_one protocol_two])
      expect(protocol_names).to receive(:mentor).exactly(2).times.and_return(%w[protocol_three])
      expect(Rails.application.config.settings).to receive(:protocol_names).exactly(4).times.and_return(protocol_names)
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
      # an informed consent given, and it should not count protocol subscriptions that do have
      # informed consent given but aren't in the list of student protocols.
      expected = studs2.count
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['number_of_students']).to eq expected
    end

    it 'should list the correct number of mentors' do
      protocol_names = double('protocol_names')
      expect(protocol_names).to receive(:student).exactly(2).times.and_return(%w[protocol_one protocol_two])
      expect(protocol_names).to receive(:mentor).exactly(2).times.and_return(%w[protocol_three])
      expect(Rails.application.config.settings).to receive(:protocol_names).exactly(4).times.and_return(protocol_names)
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
      # an informed consent given, and it should not count protocol subscriptions that do have
      # informed consent given but aren't in the list of mentor protocols.
      expected = mentors1.count
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['number_of_mentors']).to eq expected
    end

    describe 'duration_of_project_in_weeks' do
      it 'should return the correct duration of the project' do
        cached_start = ENV['PROJECT_START_DATE']
        cached_end = ENV['PROJECT_END_DATE']
        ENV['PROJECT_START_DATE'] = '2017-03-17'
        ENV['PROJECT_END_DATE'] = '2018-08-06'
        get :index
        json_response = JSON.parse(response.body)
        expected = 7 + 1 # we also count the active week
        expect(json_response['duration_of_project_in_weeks']).to eq expected
        ENV['PROJECT_START_DATE'] = cached_start
        ENV['PROJECT_END_DATE'] = cached_end
      end

      it 'should return the correct duration of the project if we are past the end date' do
        cached_start = ENV['PROJECT_START_DATE']
        cached_end = ENV['PROJECT_END_DATE']
        ENV['PROJECT_START_DATE'] = '2017-03-17'
        ENV['PROJECT_END_DATE'] = '2017-03-27'
        get :index
        json_response = JSON.parse(response.body)
        expected = 2 # we also count the active week
        expect(json_response['duration_of_project_in_weeks']).to eq expected
        ENV['PROJECT_START_DATE'] = cached_start
        ENV['PROJECT_END_DATE'] = cached_end
      end
    end

    it 'should return the correct number of completed questionnaires' do
      protocol_names = double('protocol_names')
      expect(protocol_names).to receive(:student).exactly(2).times.and_return(%w[protocol_one protocol_two])
      expect(protocol_names).to receive(:mentor).exactly(2).times.and_return(%w[protocol_three])
      expect(Rails.application.config.settings).to receive(:protocol_names).exactly(4).times.and_return(protocol_names)
      protocol1 = FactoryBot.create(:protocol, name: 'protocol_one')
      protocol2 = FactoryBot.create(:protocol, name: 'protocol_two')
      protocol3 = FactoryBot.create(:protocol, name: 'protocol_three')
      protocol4 = FactoryBot.create(:protocol, name: 'protocol_four')
      counted_measurement1 = FactoryBot.create(:measurement, protocol: protocol1)
      counted_measurement2 = FactoryBot.create(:measurement, protocol: protocol2)
      counted_measurement3 = FactoryBot.create(:measurement, protocol: protocol3)
      uncounted_measurement = FactoryBot.create(:measurement, protocol: protocol4)
      counted_responses = FactoryBot.create_list(:response, 7, :completed, measurement: counted_measurement1)
      counted_responses += FactoryBot.create_list(:response, 11, :completed, measurement: counted_measurement2)
      counted_responses += FactoryBot.create_list(:response, 13, :completed, measurement: counted_measurement3)
      FactoryBot.create_list(:response, 17, :completed, measurement: uncounted_measurement)
      expected = counted_responses.count
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['number_of_completed_questionnaires']).to eq expected
    end

    it 'should not give an error when there are no student or mentor protocol names defined' do
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
      get :index
      json_response = JSON.parse(response.body)
      # We expect zero because there are is no default protocol_names setting in Rails.application.config
      expect(json_response['number_of_students']).to eq 0
      expect(json_response['number_of_mentors']).to eq 0
      expect(json_response['number_of_completed_questionnaires']).to eq 0
    end
  end
end
