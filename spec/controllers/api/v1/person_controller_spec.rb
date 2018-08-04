# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PersonController, type: :controller do
  let(:person) { FactoryBot.create(:person, :with_iban, email: 'test@test2.com') }

  describe 'unauthorized' do
    it_should_behave_like 'an is_logged_in concern', :me
  end

  describe 'authorized' do
    describe 'show' do
      before :each do
        cookie_auth(person)
      end

      it 'should call the correct serializer' do
        allow(controller).to receive(:render)
          .with(json: person, serializer: Api::PersonSerializer)
          .and_call_original
        get :me
      end

      it 'should render the correct json' do
        get :me
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).to_not be_nil
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
