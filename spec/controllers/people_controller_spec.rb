
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:person) { FactoryBot.create(:person) }

  describe 'should not be possible to access this endpoint unauthenticated' do
    it 'should not edit' do
      get :edit
      expect(response.status).to be 401
    end

    it 'should not update' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      put :update, params: { person: person_attributes }
      expect(response.status).to be 401
    end
  end

  describe '/edit' do
    before :each do
      cookie_auth(person)
    end

    it 'should create a profile in the user object' do
      get :edit
      expect(response.status).to eq 200
      expect(controller.instance_variable_get(:@person)).to_not be_nil
      expect(controller.instance_variable_get(:@person)).to eq person

      expect(controller.instance_variable_get(:@use_mentor_layout)).to_not be_nil
      expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
    end
  end

  describe '/update' do
    before :each do
      cookie_auth(person)
    end

    it 'should update a user based on the provided attributes' do
      person_attributes = {}
      # person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      person_attributes['gender'] = 'female'
      person_attributes['first_name'] = 'firstsomething'
      person_attributes['last_name'] = 'last_something'
      person_attributes['email'] = 'email@test.com'
      person_attributes['mobile_phone'] = '0612341111'

      expect(person.gender).to_not eq person_attributes['gender']
      expect(person.first_name).to_not eq person_attributes['first_name']
      expect(person.last_name).to_not eq person_attributes['last_name']
      expect(person.email).to_not eq person_attributes['email']
      expect(person.mobile_phone).to_not eq person_attributes['mobile_phone']

      put :update, params: { person: person_attributes }

      person.reload

      expect(person.gender).to eq person_attributes['gender']
      expect(person.first_name).to eq person_attributes['first_name']
      expect(person.last_name).to eq person_attributes['last_name']
      expect(person.email).to eq person_attributes['email']
      expect(person.mobile_phone).to eq person_attributes['mobile_phone']
    end

    it 'should redirect to the klaar page' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      put :update, params: { person: person_attributes }

      expect(response.status).to eq 302
      expect(response.location).to eq klaar_url
    end

    it 'should show the correct notification' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')

      expect(flash[:notice]).to be_blank
      put :update, params: { person: person_attributes }
      expect(flash[:notice]).to_not be_blank
    end

    it 'should render edit when updated attributes are missing' do
      old_person = person
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      person_attributes['mobile_phone'] = ''
      person_attributes['first_name'] = 'somethingrandom'
      put :update, params: { person: person_attributes }

      expect(response.status).to eq 200

      # It should not have been updated
      new_person = Person.find(person.id)
      expect(old_person).to eq(new_person)
    end
  end
end
