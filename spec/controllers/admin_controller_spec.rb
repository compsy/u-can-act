# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :controller do
  describe "GET 'index'" do
    it 'should initiate an organization overview' do
      basic_auth 'admin', 'admin'
      get :index
      expect(assigns(:organization_overview)).to_not be_nil
    end
  end

  describe "GET 'routes'" do
    let(:routes_list) { %i[index person_export protocol_subscription_export] }

    it 'should require basic http auth' do
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require the correct username' do
      basic_auth 'otherusername', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require correct password' do
      basic_auth 'admin', 'otherpassword'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'response should be ok if authorized' do
      basic_auth 'admin', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_ok
      end
    end

    context 'questionnaire routes' do
      let(:routes_list) { %i[questionnaire_export response_export] }
      let!(:questionnaire) { FactoryGirl.create(:questionnaire, name: 'my-questionnaire') }

      it 'should render an error when the questionnaire cannot be found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'some_questionnaire' }
          expect(response.status).to eq 404
          expect(response.body).to eq 'Questionnaire with that name not found.'
        end
      end

      it 'should be okay when the questionnaire is found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'my-questionnaire' }
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe 'generate_organization_overview' do
    before :each do
      Timecop.freeze(2017, 5, 5)
    end

    after :each do
      Timecop.return
    end

    let!(:org1) { FactoryGirl.create(:organization, name: 'org1') }
    let!(:org2) { FactoryGirl.create(:organization, name: 'org2') }

    let!(:role1) {  FactoryGirl.create(:role, organization: org1, group: Person::STUDENT, title: 'Student') }
    let!(:role2) {  FactoryGirl.create(:role, organization: org1, group: Person::MENTOR, title: 'Mentor') }

    let!(:role3) {  FactoryGirl.create(:role, organization: org2, group: Person::STUDENT, title: 'Student') }
    let!(:role4) {  FactoryGirl.create(:role, organization: org2, group: Person::MENTOR, title: 'Mentor') }

    let!(:student1) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:student2) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:mentor1) { FactoryGirl.create(:person, :with_protocol_subscriptions, role: role2) }

    let!(:student3) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role3) }
    let!(:student4) {  FactoryGirl.create(:person, :with_protocol_subscriptions, role: role3) }
    let!(:mentor2) { FactoryGirl.create(:person, :with_protocol_subscriptions, role: role4) }

    let!(:response1) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response2) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: student2.protocol_subscriptions.first)
    end
    let!(:response3) do
      FactoryGirl.create(:response,
                         protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response4) do
      FactoryGirl.create(:response,
                         open_from: Time.zone.now + 1.day,
                         protocol_subscription: student2.protocol_subscriptions.first)
    end

    let!(:response5) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response6) do
      FactoryGirl.create(:response, :completed,
                         open_from: Time.zone.now,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response7) do
      FactoryGirl.create(:response,
                         open_from: Time.zone.now + 1.day,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response8) do
      FactoryGirl.create(:response,
                         protocol_subscription: mentor1.protocol_subscriptions.first)
    end

    it 'should generate an overview for all organizations in the db' do
      result = controller.generate_organization_overview
      expect(result).to_not be_nil
      expect(result).to be_a Array
      expect(result.length).to eq 2
      expect(result.first[:name]).to eq org1.name
      expect(result.second[:name]).to eq org2.name
    end

    it 'should list all role titles' do
      result = controller.generate_organization_overview.first[:data]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match_array [Person::STUDENT, Person::MENTOR]
    end

    it 'should list the completed measurements and total measurements for mentors' do
      result = controller.generate_organization_overview.first[:data][Person::MENTOR]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match %i[completed total]
      expect(result[:completed]).to eq 2
      expect(result[:total]).to eq 3
    end

    it 'should list the completed measurements and total measurements for students' do
      result = controller.generate_organization_overview.first[:data][Person::STUDENT]
      expect(result).to be_a Hash
      expect(result.length).to eq 2
      expect(result.keys).to match %i[completed total]
      expect(result[:completed]).to eq 2
      expect(result[:total]).to eq 3
    end
  end
end
