# frozen_string_literal: true

require 'rails_helper'

describe Api::AuthUserSerializer do
  describe 'with person' do
    let(:auth_user) { FactoryBot.create(:auth_user, :with_person) }

    subject(:json) { JSON.parse(described_class.new(auth_user).to_json) }

    it 'should contain the correct keys' do
      expect(json.keys.length).to eq 2
      expect(json.keys).to match_array %w[auth0_id_string person]
    end

    it 'should contain the correct value for the auth0_id_string' do
      expect(auth_user.auth0_id_string).to_not be_blank
      expect(json['auth0_id_string']).to eq auth_user.auth0_id_string
    end

    describe 'has a person' do
      it 'should call the person serializer for the person part' do
        expect(Api::PersonSerializer)
          .to receive(:new)
          .and_call_original
          .once
        result = JSON.parse(described_class.new(auth_user).to_json)

        # Short sanity check
        expect(result['person']['first_name']).to_not be_blank
        expect(result['person']['first_name']).to eq auth_user.person.first_name
      end
    end
  end

  describe 'without person' do
    let(:auth_user) { FactoryBot.create(:auth_user) }
    subject(:json) { described_class.new(auth_user).as_json.with_indifferent_access }
    it 'should contain the correct keys' do
      expect(json.keys.length).to eq 2
    end

    it 'should not actually have a person' do
      expect(json['person']).to be_blank
    end
  end
end
