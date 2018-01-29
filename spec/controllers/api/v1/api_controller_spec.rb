# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    describe ApiController, type: :controller do
      controller(ApiController) do
        def index
          render plain: 'Request OK'
        end
      end

      let(:test_response) { FactoryBot.create(:response) }
      let(:other_response) { FactoryBot.create(:response) }
      let(:student) { FactoryBot.create(:person) }
      let(:mentor) { FactoryBot.create(:person) }
      let(:other_person) { FactoryBot.create(:person) }
      let(:yet_another_person) { FactoryBot.create(:person) }

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
  end
end
