# frozen_string_literal: true

require 'rails_helper'

describe Api::PersonSerializer do
  let!(:person) { FactoryBot.create(:person, :with_iban, :with_auth_user, email: 'test@test.com') }
  let!(:protocol_subscription) { FactoryBot.create(:protocol_subscription, start_date: 10.minutes.ago, person: person) }
  let!(:response) do
    FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.minute.ago)
  end
  subject(:json) { JSON.parse(described_class.new(person).to_json) }

  describe 'renders the correct json' do
    it 'contains the correct attributes' do
      expect(json).not_to be_nil
      expect(json.keys).to match_array %w[
        account_active
        auth0_id_string
        id
        first_name
        last_name
        gender
        iban
        email
        mobile_phone
        my_open_responses
      ]
    end

    it 'contains the correct value for the id' do
      expect(person.id).not_to be_blank
      expect(json['id']).to eq person.id
    end

    it 'contains the correct value for the account_active' do
      expect(person.id).not_to be_blank
      expect(json['account_active']).to eq person.account_active
    end

    it 'contains the correct value for the first_name' do
      expect(person.first_name).not_to be_blank
      expect(json['first_name']).to eq person.first_name
    end

    it 'contains the correct value for the last_name' do
      expect(person.last_name).not_to be_blank
      expect(json['last_name']).to eq person.last_name
    end

    it 'contains the correct value for the mobile_phone' do
      expect(person.mobile_phone).not_to be_blank
      expect(json['mobile_phone']).to eq person.mobile_phone
    end

    it 'contains the correct value for the iban' do
      expect(person.iban).not_to be_blank
      expect(json['iban']).to eq person.iban
    end

    it 'contains the correct value for the email' do
      expect(person.email).not_to be_blank
      expect(json['email']).to eq person.email
    end

    it 'contains the correct value for the gender' do
      expect(person.gender).not_to be_blank
      expect(json['gender']).to eq person.gender
    end

    it 'contains the correct open responses' do
      expect(json['my_open_responses'].length).to eq(1)
      expect(json['my_open_responses'][0]['uuid']).to eq(response.uuid)
    end

    it 'contains the correct value for the auth0_id_string' do
      expect(person.auth_user.auth0_id_string).not_to be_blank
      expect(json['auth0_id_string']).to eq person.auth_user.auth0_id_string
    end
  end
end
