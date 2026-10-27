# frozen_string_literal: true

require 'rails_helper'

describe Person do
  describe 'email validation edge cases' do
    let(:person) { FactoryBot.create(:person) }

    context 'with valid emails' do
      valid_emails = %w[
        user@example.com
        user+tag@example.com
        first.last@example.com
        user@sub.domain.com
        user@sub.domain2.com
        user@123.example.com
        user@a-b.example.com
        user@mail.co.uk
        USER@EXAMPLE.COM
        user@example.museum
        user@example.travel
        a@b.co
        user-name@example.com
        user_name@example.com
        user+mailbox@example.com
        firstname.lastname@example.com
        user@sub-domain.example.com
        user@123-domain.example.com
      ]

      valid_emails.each do |email|
        it "accepts '#{email}'" do
          person.email = email
          expect(person).to be_valid
        end
      end
    end

    context 'with invalid emails' do
      invalid_emails = %w[
        user@
        @example.com
        user@@example.com
        user..name@example.com
        user@.example.com
        user@example..com
        user@example
        user@example.
      ]

      invalid_emails.each do |email|
        it "rejects '#{email}'" do
          person.email = email
          expect(person).not_to be_valid
          expect(person.errors.messages).to have_key(:email)
          expect(person.errors.messages[:email]).to include('is ongeldig')
        end
      end
    end

    context 'with blank values' do
      it 'accepts nil' do
        person.email = nil
        expect(person).to be_valid
      end

      it 'accepts empty string' do
        person.email = ''
        expect(person).to be_valid
      end
    end

    context 'with digits in domain parts' do
      it 'accepts digits in subdomain' do
        person.email = 'user@mail2.example.com'
        expect(person).to be_valid
      end

      it 'accepts digits in intermediate domain parts' do
        person.email = 'user@sub.domain2.example.com'
        expect(person).to be_valid
      end

      it 'accepts a fully numeric first domain label' do
        person.email = 'user@123.example.com'
        expect(person).to be_valid
      end
    end

    context 'with hyphens in domain parts' do
      it 'accepts hyphens in subdomain' do
        person.email = 'user@my-mail.example.com'
        expect(person).to be_valid
      end

      it 'accepts hyphens in intermediate domain parts' do
        person.email = 'user@sub.my-domain.example.com'
        expect(person).to be_valid
      end
    end
  end
end
