# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApiController, type: :controller do
  controller(Api::V1::ApiController) do
    def create
      raise_bad_request
    end

    def index
      # This will raise!
      ActionController::Parameters.new(protocol: {}).require(:protocol)
    end
  end

  let(:test_response) { FactoryBot.create(:response) }
  let(:other_response) { FactoryBot.create(:response) }
  let(:student) { FactoryBot.create(:person) }
  let(:mentor) { FactoryBot.create(:person) }
  let(:other_person) { FactoryBot.create(:person) }
  let(:yet_another_person) { FactoryBot.create(:person) }

  describe 'raise_bad_request' do
    it 'should render a 400 when called' do
      post :create
      expect(response.status).to eq 400
      expect(response.body).to eq 'Error while parsing json parameters: '
    end
  end

  describe 'ParameterMissing' do
    it 'should head a 422 whenever the parameter missing error occurs' do
      get :index
      expect(response.status).to eq 422
    end

    it 'should head a json with the correct message when this error is thrown' do
      get :index
      result = response.body
      result = JSON.parse(result)
      expect(result.keys).to eq ['errors']
      expect(result['errors']).to eq ["'protocol' parameter is verplicht"]
    end
  end

  describe 'check_access_allowed' do
    before :each do
      controller.instance_variable_set(:@response, test_response)
      controller.instance_variable_set(:@current_user, test_response.protocol_subscription.person)
    end

    it 'should return true if the protocol subscription is mine' do
      expect(controller.check_access_allowed(test_response.protocol_subscription)).to be_truthy
    end

    it 'should return true if the protocol subscription is for one of a mentor his or her students' do
      current_person = test_response.protocol_subscription.person
      test_response.protocol_subscription.update_attributes!(filling_out_for: other_person, person: current_person)
      controller.instance_variable_set(:@response, test_response)
      expect(controller.check_access_allowed(test_response.protocol_subscription)).to be_truthy
    end
    it 'should return false if Im the student for which the mentor has filled out this questionnaire' do
      current_person = test_response.protocol_subscription.filling_out_for
      test_response.protocol_subscription.update_attributes!(filling_out_for: current_person, person: other_person)
      controller.instance_variable_set(:@response, test_response)
      expect(controller.check_access_allowed(test_response.protocol_subscription)).to be_falsey
    end
    it 'should return true if this is a student Im supervising, eventhough this isnt the psub Im supervising in' do
      # This is a regular, plain student protocol (filling out for him/her self)
      current_response = FactoryBot.create(:response)
      current_response.protocol_subscription.update_attributes!(person: student, filling_out_for: student)

      # In this protocol I'm supervising the student
      other_response = FactoryBot.create(:response)
      other_response.protocol_subscription.update_attributes!(person: mentor, filling_out_for: student)

      controller.instance_variable_set(:@response, current_response)
      controller.instance_variable_set(:@current_user, mentor)
      expect(controller.check_access_allowed(current_response.protocol_subscription)).to be_truthy
    end
    it 'should return false if Im a person but this is not my student nor am I the student' do
      # This is a regular, plain student protocol (filling out for him/her self)
      current_response = FactoryBot.create(:response)
      current_response.protocol_subscription.update_attributes!(person: student, filling_out_for: student)

      # In this protocol I'm supervising a different student
      other_response = FactoryBot.create(:response)
      other_response.protocol_subscription.update_attributes!(person: mentor, filling_out_for: other_person)

      controller.instance_variable_set(:@response, current_response)
      controller.instance_variable_set(:@current_user, mentor)
      expect(controller.check_access_allowed(current_response.protocol_subscription)).to be_falsey
    end
    it 'should return false otherwise' do
      expect(controller.check_access_allowed(other_response.protocol_subscription)).to be_falsey
    end
  end
end
