# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PersonController, type: :controller do
  let(:person) { FactoryBot.create(:person, :with_iban, email: 'test@test2.com') }

  describe 'unauthorized' do
    it_behaves_like 'an is_logged_in concern', :me, {}
  end

  describe 'authorized' do
    before do
      cookie_auth(person)
    end
    describe 'update' do
      it 'renders the correct errors if something goes wrong' do
        new_email = 'newtest.com'
        put :person, params: { person: { email: new_email } }
        expect(response.status).to eq 422
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['status']).to eq 'not ok'
        expect(json['errors']).to include 'email'
        expect(json['errors']['email']).to include 'is ongeldig'
      end

      it 'updates the current user' do
        new_email = 'new@test.com'
        put :person, params: { person: { email: new_email } }
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['status']).to eq 'ok'
        expect(person.email).to eq new_email
      end
     end
    end

    describe 'me' do
      it 'calls the correct serializer' do
        allow(controller).to receive(:render)
          .with(json: person, serializer: Api::PersonSerializer)
          .and_call_original
        get :me
      end

      it 'renders the correct json' do
        get :me
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['first_name']).to eq person.first_name
        expect(json['last_name']).to eq person.last_name
        expect(json['mobile_phone']).to eq person.mobile_phone
        expect(json['gender']).to eq person.gender
        expect(json['email']).to eq person.email
        expect(json['iban']).to eq person.iban
      end
    end
  end
end
