# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthUser, type: :model do
  describe 'constants' do
    it 'should have an AUTH0_KEY_LOCATION' do
      expect(described_class::AUTH0_KEY_LOCATION).to_not be_blank
    end
    it 'should have an SITE_LOCATION' do
      expect(described_class::SITE_LOCATION).to_not be_blank
    end
  end
  describe 'validity_check' do
    it 'should have a factory that is valid' do
      result = FactoryBot.build(:auth_user)
      expect(result).to be_valid
    end
  end
  describe 'from_token_payload' do
    let(:incorrect_payload) do
      {
        'this' => 'should not be here'
      }
    end

    let(:incorrect_payload_no_site) do
      {
        described_class::AUTH0_KEY_LOCATION => 'thesubprovidedbyauth0'
      }
    end

    let(:correct_payload) do
      {
        described_class::AUTH0_KEY_LOCATION => 'thesubprovidedbyauth0',
        described_class::SITE_LOCATION => {
          'roles' => ['admin'],
          'team' => 'kct',
          'protocol' => 'KCT'
        }
      }
    end

    it 'should raise if the payload (sub) is invalid' do
      expect { described_class.from_token_payload(incorrect_payload) }
        .to raise_error RuntimeError, "Invalid payload #{incorrect_payload} - no sub key"
    end

    it 'should raise if the payload (metadata) is invalid' do
      expect { described_class.from_token_payload(incorrect_payload_no_site) }
        .to raise_error RuntimeError, "Invalid payload #{incorrect_payload_no_site} - no site key"
    end

    it 'should create an anonymous user with the correct id and team' do
      expect(CreateAnonymousUser)
        .to receive(:run!)
        .with(auth0_id_string: correct_payload[described_class::AUTH0_KEY_LOCATION],
              team_name: correct_payload[described_class::SITE_LOCATION]['team'])
        .and_raise('stop_execution')

      expect { described_class.from_token_payload(correct_payload) }.to raise_error 'stop_execution'
    end

    it 'should return the created auth_user' do
      FactoryBot.create(:protocol,
                        name: correct_payload[described_class::SITE_LOCATION]['protocol'])
      FactoryBot.create(:team,
                        :with_roles,
                        name: correct_payload[described_class::SITE_LOCATION]['team'])
      result = described_class.from_token_payload(correct_payload)
      expect(result).to be_a described_class
    end

    describe 'creates protocol subscriptions' do
      it 'should create new protocol subscriptions if the user does not yet have some' do
        auth_user = FactoryBot.create(:auth_user, :with_person)
        expect(CreateAnonymousUser)
          .to receive(:run!)
          .and_return(auth_user)
        expect(SubscribeToProtocol)
          .to receive(:run!)
          .with(protocol_name: correct_payload[described_class::SITE_LOCATION]['protocol'],
                person: auth_user.person)
          .and_raise('stop_execution')
        expect(auth_user.person.protocol_subscriptions).to be_blank
        expect { described_class.from_token_payload(correct_payload) }.to raise_error 'stop_execution'
      end

      it 'should not create new protocol subscriptions for users already subscribed to this protocol' do
        auth_user = FactoryBot.create(:auth_user, :with_person)
        protocol = FactoryBot.create(:protocol,
                                     name: correct_payload[described_class::SITE_LOCATION]['protocol'])
        FactoryBot.create(:protocol_subscription, person: auth_user.person, protocol: protocol)

        expect(CreateAnonymousUser)
          .to receive(:run!)
          .and_return(auth_user)
        expect(SubscribeToProtocol)
          .to_not receive(:run!)

        expect(auth_user.person.protocol_subscriptions).to_not be_blank
        result = described_class.from_token_payload(correct_payload)
        expect(result).to equal(auth_user)
      end

      it 'should not create new protocol subscriptions for users already subscribed to this protocol' do
        auth_user = FactoryBot.create(:auth_user, :with_person)
        protocol = FactoryBot.create(:protocol,
                                     name: 'something completely unrelated')
        FactoryBot.create(:protocol_subscription, person: auth_user.person, protocol: protocol)

        expect(CreateAnonymousUser)
          .to receive(:run!)
          .and_return(auth_user)
        expect(SubscribeToProtocol)
          .to receive(:run!)
          .and_return(true)

        expect(auth_user.person.protocol_subscriptions).to_not be_blank
        result = described_class.from_token_payload(correct_payload)
        expect(result).to equal(auth_user)
      end
    end
  end
end
