# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CookieAndJwtApi::PersonController, type: :controller do
  let(:person) { FactoryBot.create(:person, :with_iban, email: 'test@test2.com') }
  let!(:auth_user) { FactoryBot.create(:auth_user, person: person) }

  describe 'unauthorized' do
    it_behaves_like 'an is_logged_in concern', :me, {}
  end

  describe 'authorized' do
    before do
      cookie_auth(person)
      @old = ENV['TOKEN_SIGNATURE_ALGORITHM']
      ENV['TOKEN_SIGNATURE_ALGORITHM'] = 'HS256'
    end

    after do
      ENV['TOKEN_SIGNATURE_ALGORITHM'] = @old
    end

    describe 'update' do
      it 'renders the correct errors if something goes wrong' do
        new_email = 'newtest.com'
        put :update, params: { person: { email: new_email } }
        expect(response.status).to eq 422
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)['errors'][0]
        expect(json['status']).to eq '422'
        expect(json['title']).to eq 'unprocessable'
        expect(json['detail']).to include 'email'
        expect(json['detail']['email']).to include 'is ongeldig'
      end

      it 'updates the current user' do
        new_email = 'new@test.com'
        put :update, params: { person: { email: new_email } }
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['status']).to eq 'ok'
        person.reload
        expect(person.email).to eq new_email
      end

      it 'does not update if the given timestamp is older than the last update' do
        person_attributes = {}
        person_attributes['email'] = 'email@test.com'
        person_attributes['locale'] = 'en'
        person_attributes['timestamp'] = (Time.current - 1.minute).to_s
        person.update!(locale: 'nl')

        put :update, params: { person: person_attributes }

        expect(response.status).to eq 422
        person.reload
        expect(person.locale).to eq('nl')
      end

      it 'updates a user if the given timestamp is newer than the last update' do
        person_attributes = {}
        person_attributes['email'] = 'email@test.com'
        person_attributes['locale'] = 'en'
        person.update!(locale: 'nl')
        person_attributes['timestamp'] = (Time.current + 1.minute).to_s

        put :update, params: { person: person_attributes }

        expect(response.status).to eq 200
        person.reload
        expect(person.locale).to eq('en')
      end

      it 'updates a user if no timestamp is given' do
        person_attributes = {}
        person_attributes['email'] = 'email@test.com'
        person_attributes['locale'] = 'en'
        person.update!(locale: 'nl')

        put :update, params: { person: person_attributes }

        expect(response.status).to eq 200
        person.reload
        expect(person.locale).to eq('en')
      end

      it 'updates a user to a nil email if a blank value was given' do
        expect(person.email).to_not be_blank
        person_attributes = {}
        person_attributes['email'] = ''
        put :update, params: { person: person_attributes }
        expect(response.status).to eq 200
        person.reload
        expect(person.email).to be_nil
      end

      it 'updates a user to a nil mobile_phone if a blank value was given' do
        expect(person.mobile_phone).to_not be_blank
        person_attributes = {}
        person_attributes['mobile_phone'] = ''
        put :update, params: { person: person_attributes }
        expect(response.status).to eq 200
        person.reload
        expect(person.mobile_phone).to be_nil
      end
    end

    describe 'destroy' do
      it 'renders the correct errors if something goes wrong' do
        person.destroy
        auc = AuthUser.count
        pc = Person.count
        delete :destroy, params: {}
        expect(Person.count).to eq pc
        expect(AuthUser.count).to eq auc
        expect(response.status).to eq 401
      end

      it 'destroys the current user' do
        auc = AuthUser.count
        pc = Person.count
        person_id = person.id
        delete :destroy, params: {}
        expect(Person.count + 1).to eq pc
        expect(AuthUser.count + 1).to eq auc
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).not_to be_nil
        expect(json['status']).to eq 'ok'
        person = Person.where(id: person_id).first
        expect(person).to be_blank
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
