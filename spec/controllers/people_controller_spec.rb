# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:person) { FactoryBot.create(:person) }

  describe 'should not be possible to access this endpoint unauthenticated' do
    it 'does not edit' do
      get :edit
      expect(response.status).to be 401
    end

    it 'does not update' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      put :update, params: { person: person_attributes }
      expect(response.status).to be 401
    end
  end

  describe '/edit' do
    before do
      cookie_auth(person)
    end

    it 'creates a profile in the user object' do
      get :edit
      expect(response.status).to eq 200
      expect(controller.instance_variable_get(:@person)).not_to be_nil
      expect(controller.instance_variable_get(:@person)).to eq person

      expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
      expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
    end
  end

  describe '/unsubscribe' do
    before do
      cookie_auth(person)
    end

    it 'redirects to the klaar page without any active protocol subscriptions' do
      get :unsubscribe
      expect(response.status).to eq 302
      expect(response.body).to match %r{/klaar}
      expect(controller.instance_variable_get(:@person)).not_to be_nil
      expect(controller.instance_variable_get(:@person)).to eq person

      expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
      expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
    end

    it 'redirects to the klaar page and cancel any active protocol subscriptions' do
      FactoryBot.create_list(:protocol_subscription, 5, person: person)
      expect(person.protocol_subscriptions.active.count).to eq 5
      get :unsubscribe
      expect(person.protocol_subscriptions.active.count).to eq 0
      expect(person.protocol_subscriptions.count).to eq 5
      expect(response.status).to eq 302
      expect(response.body).to match %r{/klaar}
      expect(controller.instance_variable_get(:@person)).not_to be_nil
      expect(controller.instance_variable_get(:@person)).to eq person

      expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
      expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
    end

    it 'redirects to a stop response if there is one' do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement, :stop_measurement,
                        protocol: protocol,
                        open_from_offset: (2.days + 13.hours).to_i)

      FactoryBot.create(:protocol_subscription,
                        person: person,
                        protocol: protocol,
                        start_date: 1.day.ago.at_beginning_of_day)
      get :unsubscribe
      expect(person.protocol_subscriptions.active.count).to eq 1
      expect(response.status).to eq 302
      expect(response.body).to match %r{/questionnaire}
      expect(response.body).to match(/\?callback_url=%2Fperson%2Funsubscribe/)
      expect(controller.instance_variable_get(:@person)).not_to be_nil
      expect(controller.instance_variable_get(:@person)).to eq person

      expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
      expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
    end

    context 'for mentors' do
      it 'redirects to the mentor overview page without any active protocol subscriptions' do
        person = FactoryBot.create(:mentor)
        cookie_auth(person)
        get :unsubscribe
        expect(response.status).to eq 302
        expect(response.body).to match %r{/mentor_overview}
        expect(controller.instance_variable_get(:@person)).not_to be_nil
        expect(controller.instance_variable_get(:@person)).to eq person

        expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
        expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
      end

      it 'redirects to the klaar page and cancel any active protocol subscriptions' do
        person = FactoryBot.create(:mentor)
        cookie_auth(person)
        FactoryBot.create_list(:protocol_subscription, 5, person: person)
        FactoryBot.create_list(:protocol_subscription, 5, :mentor, person: person)
        expect(person.protocol_subscriptions.active.count).to eq 10
        get :unsubscribe
        expect(person.protocol_subscriptions.active.count).to eq 0
        expect(person.protocol_subscriptions.count).to eq 10
        expect(response.status).to eq 302
        expect(response.body).to match %r{/mentor_overview}
        expect(controller.instance_variable_get(:@person)).not_to be_nil
        expect(controller.instance_variable_get(:@person)).to eq person

        expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
        expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
      end

      it 'redirects to a stop response if there is one' do
        person = FactoryBot.create(:mentor)
        cookie_auth(person)
        protocol = FactoryBot.create(:protocol)
        FactoryBot.create(:measurement, :stop_measurement,
                          protocol: protocol,
                          open_from_offset: (2.days + 13.hours).to_i)
        protocol.reload

        FactoryBot.create(:protocol_subscription,
                          person: person,
                          protocol: protocol,
                          start_date: 1.day.ago.at_beginning_of_day)
        get :unsubscribe
        expect(person.protocol_subscriptions.active.count).to eq 1
        expect(response.status).to eq 302
        expect(response.body).to match %r{/questionnaire}
        expect(response.body).to match(/\?callback_url=%2Fperson%2Funsubscribe/)
        expect(controller.instance_variable_get(:@person)).not_to be_nil
        expect(controller.instance_variable_get(:@person)).to eq person

        expect(controller.instance_variable_get(:@use_mentor_layout)).not_to be_nil
        expect(controller.instance_variable_get(:@use_mentor_layout)).to eq person.mentor?
      end
    end
  end

  describe '/update' do
    before do
      cookie_auth(person)
    end

    it 'updates a user based on the provided attributes' do
      person_attributes = {}
      # person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      person_attributes['gender'] = 'female'
      person_attributes['first_name'] = 'firstsomething'
      person_attributes['last_name'] = 'last_something'
      person_attributes['email'] = 'email@test.com'
      person_attributes['mobile_phone'] = '0612341111'

      expect(person.gender).not_to eq person_attributes['gender']
      expect(person.first_name).not_to eq person_attributes['first_name']
      expect(person.last_name).not_to eq person_attributes['last_name']
      expect(person.email).not_to eq person_attributes['email']
      expect(person.mobile_phone).not_to eq person_attributes['mobile_phone']

      put :update, params: { person: person_attributes }

      person.reload

      expect(person.gender).to eq person_attributes['gender']
      expect(person.first_name).to eq person_attributes['first_name']
      expect(person.last_name).to eq person_attributes['last_name']
      expect(person.email).to eq person_attributes['email']
      expect(person.mobile_phone).to eq person_attributes['mobile_phone']
    end

    it 'does not store the iphash of the person if the person cant store it' do
      person_attributes = { 'gender' => 'female' }
      expect(person.ip_hash).to be_blank
      put :update, params: { person: person_attributes }
      person.reload
      expect(person.gender).to eq person_attributes['gender']
      expect(person.ip_hash).to be_blank
    end

    describe 'with a person that can store ips' do
      let(:person) { FactoryBot.create(:solo) }

      before do
        cookie_auth(person)
      end

      it 'stores the iphash of the person if the person can store it' do
        person_attributes = { 'gender' => 'female' }
        expect(person.gender).not_to eq person_attributes['gender']
        expect(person.ip_hash).to be_blank
        put :update, params: { person: person_attributes }
        person.reload
        expect(person.gender).to eq person_attributes['gender']
        expect(person.ip_hash).not_to be_blank
        expect(person.ip_hash).to eq HashGenerator.generate(request.remote_ip, salt: ENV['IP_HASH_SALT'])
      end

      it 'crashes if the salt is not set in the ENV' do
        pre = ENV['IP_HASH_SALT']
        ENV['IP_HASH_SALT'] = nil
        person_attributes = { 'gender' => 'female' }
        expect { put :update, params: { person: person_attributes } }
          .to raise_error KeyError, 'key not found: "IP_HASH_SALT"'
        ENV['IP_HASH_SALT'] = pre
      end
    end

    it 'redirects to the klaar page' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      put :update, params: { person: person_attributes }

      expect(response.status).to eq 302
      expect(response.location).to end_with klaar_path
    end

    it 'shows the correct notification' do
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')

      expect(flash[:notice]).to be_blank
      put :update, params: { person: person_attributes }
      expect(flash[:notice]).not_to be_blank
    end

    it 'renders edit when updated attributes are missing' do
      old_person = person
      person_attributes = person.attributes.slice('email', 'first_name', 'last_name', 'email', 'mobile_phone')
      person_attributes['mobile_phone'] = '0612341234'
      person_attributes['first_name'] = ''
      put :update, params: { person: person_attributes }

      expect(response.status).to eq 200

      # It should not have been updated
      new_person = Person.find(person.id)
      expect(old_person).to eq(new_person)
    end
  end
end
