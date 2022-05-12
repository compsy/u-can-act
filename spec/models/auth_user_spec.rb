# frozen_string_literal: true

require 'rails_helper'

describe AuthUser, type: :model do
  describe 'constants' do
    it 'should have an AUTH0_KEY_LOCATION' do
      expect(described_class::AUTH0_KEY_LOCATION).to_not be_blank
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

    let(:correct_payload_no_site) do
      {
        described_class::AUTH0_KEY_LOCATION => 'thesubprovidedbyauth0'
      }
    end

    let(:correct_payload) do
      {
        described_class::AUTH0_KEY_LOCATION => 'thesubprovidedbyauth0',
        ENV.fetch('SITE_LOCATION', nil) => {
          'access_level' => ['admin'],
          'role' => 'Studenttitle',
          'email' => 'test@example.com',
          'team' => 'kct',
          'protocol' => 'KCT'
        }
      }
    end

    let(:deprecated_payload) do
      {
        described_class::AUTH0_KEY_LOCATION => 'thesubprovidedbyauth0',
        ENV.fetch('SITE_LOCATION', nil) => {
          'roles' => ['admin'], # The roles param is deprecated
          'team' => 'kct',
          'protocol' => 'KCT'
        }
      }
    end

    it 'should raise if the payload (sub) is invalid' do
      expect { described_class.from_token_payload(incorrect_payload) }
        .to raise_error RuntimeError, "Invalid payload #{incorrect_payload} - no sub key"
    end

    it 'should give a deprecation warning with the old payload' do
      expect(CreateAnonymousUser)
        .to receive(:run!)
        .with(any_args)
        .and_raise('stop_execution')

      expect(ActiveSupport::Deprecation)
        .to receive(:warn)
        .with(any_args)
      expect { described_class.from_token_payload(deprecated_payload) }.to raise_error 'stop_execution'
    end

    it 'should create an anonymous user with the correct id and team' do
      expect(CreateAnonymousUser)
        .to receive(:run!)
        .with(auth0_id_string: correct_payload[described_class::AUTH0_KEY_LOCATION],
              team_name: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['team'],
              role_title: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['role'],
              email: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['email'],
              access_level: AuthUser::ADMIN_ACCESS_LEVEL)
        .and_raise('stop_execution')
      expect { described_class.from_token_payload(correct_payload) }.to raise_error 'stop_execution'
    end

    it 'should return the created auth_user' do
      FactoryBot.create(:protocol,
                        name: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['protocol'])
      FactoryBot.create(:team,
                        :with_roles,
                        name: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['team'])
      result = described_class.from_token_payload(correct_payload)
      expect(result).to be_a described_class
    end

    # it 'should just create an auth_user if the metadata is missing' do
    #   pre_count = ProtocolSubscription.count
    #   result = described_class.from_token_payload(correct_payload_no_site)
    #   expect(result).to be_a AuthUser
    #   expect(result.person).to be_blank
    #   post_count = ProtocolSubscription.count
    #   expect(pre_count).to eq post_count
    # end

    describe 'creates protocol subscriptions' do
      it 'should create new protocol subscriptions if the user does not yet have some' do
        auth_user = FactoryBot.create(:auth_user, :with_person)
        expect(CreateAnonymousUser)
          .to receive(:run!)
          .and_return(auth_user)
        expect(SubscribeToProtocol)
          .to receive(:run!)
          .with(protocol_name: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['protocol'],
                person: auth_user.person)
          .and_raise('stop_execution')
        expect(auth_user.person.protocol_subscriptions).to be_blank
        expect { described_class.from_token_payload(correct_payload) }.to raise_error 'stop_execution'
      end

      it 'should not create new protocol subscriptions for users already subscribed to this protocol' do
        auth_user = FactoryBot.create(:auth_user, :with_person)
        protocol = FactoryBot.create(:protocol,
                                     name: correct_payload[ENV.fetch('SITE_LOCATION', nil)]['protocol'])
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

# frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe Admin, type: :model do
# let!(:admin) { FactoryBot.create(:admin) }
# let!(:admin2) { FactoryBot.create(:admin) }
# describe 'validations' do
# it 'should have a valid factory' do
# expect(FactoryBot.build(:admin)).to be_valid
# end
# describe 'auth0_id_string' do
# it 'should validate the uniqueness of the auth0_id_string' do
# admin.auth0_id_string = admin2.auth0_id_string
# expect(admin).to_not be_valid
# end

# it 'should validate the presence of the auth0_id_string' do
# admin.auth0_id_string = nil
# expect(admin).to_not be_valid
# end
# end
# end
# describe 'from_token_payload' do
# it 'should create a new admin from the token payload' do
# pre = Admin.count
# payload = { described_class::AUTH0_KEY_LOCATION => '1234' }
# result = Admin.from_token_payload(payload)
# post = Admin.count
# expect(post).to eq pre + 1
# expect(result).to be_an Admin
# expect(result.auth0_id_string).to eq payload[described_class::AUTH0_KEY_LOCATION]
# end

# it 'should not create a new admin when one with the same auth0_id_string already exists' do
# payload = { described_class::AUTH0_KEY_LOCATION => admin.auth0_id_string }
# pre = Admin.count
# result = Admin.from_token_payload(payload)
# post = Admin.count

# expect(post).to eq pre
# expect(result).to be_an Admin
# expect(result.auth0_id_string).to eq payload[described_class::AUTH0_KEY_LOCATION]
# end

# it 'should raise if the payload is misspecified' do
# payload = { 'something' => '1234' }
# pre = Admin.count
# expect { Admin.from_token_payload(payload) }.to raise_error(RuntimeError, "Invalid payload #{payload}")
# post = Admin.count
# expect(post).to eq pre
# end
# end
# end
