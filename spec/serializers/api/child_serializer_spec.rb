# frozen_string_literal: true

require 'rails_helper'

describe Api::ChildSerializer do
  subject(:json) { described_class.new(person).as_json.with_indifferent_access }

  let!(:person) { FactoryBot.create(:person, email: 'test@test.com') }

  describe 'renders the correct json' do
    it 'contains the correct variables' do
      expect(json).not_to be_nil
      expect(json.keys).to match_array %w[id first_name email account_active role]
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

    it 'contains the correct value for the email' do
      expect(person.email).not_to be_blank
      expect(json['email']).to eq person.email
    end

    it 'contains the correct value for the role' do
      expect(person.role.title).not_to be_blank
      expect(json['role']).to eq person.role.title
    end
  end
end
