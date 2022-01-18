# frozen_string_literal: true

require 'rails_helper'

describe InvitationToken do
  it 'has valid default properties' do
    invitation_token = FactoryBot.create(:invitation_token)
    expect(invitation_token).to be_valid
  end

  describe 'expires_at' do
    it 'initializes by default' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.expires_at).not_to be_nil
    end

    it 'initializes with the correct OPEN_FROM_INVITATION' do
      date = Time.zone.local(2017, 11, 0o2, 0, 0)
      Timecop.freeze(date)
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.expires_at)
        .to be_within(1.minute)
        .of(date + described_class::OPEN_TIME_FOR_INVITATION)
    end
  end

  describe 'test_token' do
    it 'calls the test_identifier_token_combination function with the correct parameters' do
      identifier = 'abcd'
      token = '1234'
      full_token = "#{identifier}#{token}"

      expect(described_class).to receive(:test_identifier_token_combination)
        .with(identifier, token)
        .and_return(true)

      expect(described_class.test_token(full_token)).to be_truthy
    end

    it 'returns nil if the provided full_token is nil' do
      expect(described_class.test_token(nil)).to be_nil
    end

    it 'returns nil if the provided full_token is too short' do
      identifier = 'abcd'
      token = '123'
      full_token = "#{identifier}#{token}"

      expect(described_class.test_token(full_token)).to be_nil
    end
  end

  describe 'test_identifier_token_combination' do
    let(:other_person) { FactoryBot.create(:person) }

    let(:responseobj) { FactoryBot.create(:response, :invited) }
    let(:token) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    let(:not_sent_response) { FactoryBot.create(:response) }
    let(:not_sent_token) { FactoryBot.create(:invitation_token) }

    it 'returns nil if there is no person with that identifier' do
      result = described_class.test_identifier_token_combination('non_existent', token.token_plain)
      expect(result).to be_nil
    end

    it 'returns nil if the person has no responses' do
      result = described_class.test_identifier_token_combination(other_person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'returns nil if the token does not match any of the responses' do
      person = responseobj.protocol_subscription.person
      result = described_class.test_identifier_token_combination(person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'returns nil if the token matches an unsent response' do
      person = responseobj.protocol_subscription.person
      result = described_class.test_identifier_token_combination(person.external_identifier, not_sent_token.token_plain)
      expect(result).to be_nil
    end

    it 'returns nil if there is one that matches the description but the hashed token is provided' do
      person = responseobj.protocol_subscription.person
      result = described_class.test_identifier_token_combination(person.external_identifier, token.token)
      expect(result).to be_nil
    end

    it 'returns the invitation_token if there is one that matches the description' do
      person = responseobj.protocol_subscription.person
      result = described_class.test_identifier_token_combination(person.external_identifier, token.token_plain)
      expect(result).to eq responseobj.invitation_set.invitation_tokens.first
    end

    it 'returns the invitation_token if there is one that matches the description and is completed' do
      responseobj.update!(completed_at: Time.zone.now)
      person = responseobj.protocol_subscription.person
      result = described_class.test_identifier_token_combination(person.external_identifier, token.token_plain)
      expect(result).to eq responseobj.invitation_set.invitation_tokens.first
    end
  end

  describe 'token_hash' do
    it 'does not allow duplicate token hashes' do
      tok = 'myinvitation_token'
      invitation_tokenone = FactoryBot.create(:invitation_token, token: tok)
      expect(invitation_tokenone.token_plain).to eq tok
      expect(invitation_tokenone.token).not_to be_empty
      expect(invitation_tokenone.token.to_s).not_to eq tok
      expect(invitation_tokenone).to be_valid
      invitation_tokentwo = FactoryBot.create(:invitation_token, token: tok)
      expect(invitation_tokentwo.token_plain).to eq tok
      expect(invitation_tokentwo.token).not_to be_empty
      expect(invitation_tokenone.token.to_s).not_to eq tok
      expect(invitation_tokentwo).to be_valid
      expect(invitation_tokentwo.token.to_s).not_to eq invitation_tokenone.token.to_s
    end
    it 'does not accept a nil token_hash' do
      invitation_token = FactoryBot.create(:invitation_token)
      invitation_token.token_hash = nil
      expect(invitation_token).not_to be_valid
      expect(invitation_token.errors.messages).to have_key :token_hash
      expect(invitation_token.errors.messages[:token_hash]).to include('moet opgegeven zijn')
    end
    it 'does not accept a blank token_hash' do
      invitation_token = FactoryBot.create(:invitation_token)
      invitation_token.token_hash = ''
      expect(invitation_token).not_to be_valid
      expect(invitation_token.errors.messages).to have_key :token_hash
      expect(invitation_token.errors.messages[:token_hash]).to include('moet opgegeven zijn')
    end
  end

  describe 'token' do
    it 'generates a token if no token is present' do
      invitation_tokenone = FactoryBot.create(:invitation_token)
      expect(invitation_tokenone.token).not_to be_empty
      expect(invitation_tokenone.token_plain).not_to be_empty
      expect(invitation_tokenone).to be_valid
    end

    it 'uses the old token_plain if it is present' do
      pt_token = 'tokenhere'
      invitation_token = FactoryBot.create(:invitation_token, token: pt_token)
      expect(invitation_token.token_plain).to eq pt_token
    end

    it 'onlies store encrypted versions of the token' do
      pt_token = 'tokenhere'
      invitation_token = FactoryBot.create(:invitation_token, token: pt_token)
      expect(invitation_token.token_plain).not_to be_blank

      invitation_token = described_class.find(invitation_token.id)
      expect(invitation_token.token_plain).to be_blank
      expect(invitation_token.token).not_to be_blank
    end
  end

  describe 'invitation_set_id' do
    it 'has one' do
      invitation_token = FactoryBot.create(:invitation_token)
      invitation_token.invitation_set_id = nil
      expect(invitation_token).not_to be_valid
      expect(invitation_token.errors.messages).to have_key :invitation_set
      expect(invitation_token.errors.messages[:invitation_set]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve an InvitationSet' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.invitation_set).to be_an(InvitationSet)
    end
  end

  describe 'expires_at' do
    it 'is not able to be nil' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: nil)
      expect(invitation_token.expires_at).not_to be_nil
    end
    it 'is able to set it to a value' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 14.days.from_now.in_time_zone)
      expect(invitation_token.expires_at).to be_within(1.minute).of(14.days.from_now.in_time_zone)
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation_token.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'expired?' do
    it 'returns false if it expires in the future' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 10.days.from_now)
      expect(invitation_token).not_to be_expired
    end

    it 'returns false if it expires right now' do
      Timecop.freeze(2017, 5, 5) do
        invitation_token = FactoryBot.create(:invitation_token, expires_at: Time.zone.now)
        expect(invitation_token).not_to be_expired
      end
    end

    it 'returns true if it expired in the past' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 10.days.ago)
      expect(invitation_token).to be_expired
    end
  end

  describe 'calculate_expires_at' do
    context 'without responses' do
      it 'returns 7 days since created_at if it was created in the past week' do
        invitation_set = FactoryBot.create(:invitation_set)
        invitation_token = FactoryBot.create(:invitation_token,
                                             invitation_set: invitation_set,
                                             created_at: 3.days.ago)
        expected = TimeTools.increase_by_duration(invitation_token.created_at,
                                                  described_class::OPEN_TIME_FOR_INVITATION)
        expect(invitation_token.calculate_expires_at).to be_within(1.minute).of(expected)
      end
    end

    context 'with responses' do
      it 'does not count completed responses' do
        measurement = FactoryBot.create(:measurement, open_duration: 10.days)
        invitation_set = FactoryBot.create(:invitation_set)
        invitation_token = FactoryBot.create(:invitation_token,
                                             invitation_set: invitation_set,
                                             created_at: 3.days.ago)
        response = FactoryBot.create(:response,
                                     open_from: 1.hour.ago,
                                     invitation_set: invitation_set,
                                     measurement: measurement)
        response.complete!
        expected = TimeTools.increase_by_duration(invitation_token.created_at,
                                                  described_class::OPEN_TIME_FOR_INVITATION)
        expect(invitation_token.calculate_expires_at).to be_within(1.minute).of(expected)
      end
      it 'returns the expires at from the response if the invitation token was created more than 7 days ago' do
        measurement = FactoryBot.create(:measurement, open_duration: 2.days)
        invitation_set = FactoryBot.create(:invitation_set)
        invitation_token = FactoryBot.create(:invitation_token,
                                             invitation_set: invitation_set,
                                             created_at: 8.days.ago)
        response = FactoryBot.create(:response,
                                     open_from: 1.hour.ago,
                                     invitation_set: invitation_set,
                                     measurement: measurement)
        expected = TimeTools.increase_by_duration(response.open_from, measurement.open_duration)
        expect(invitation_token.calculate_expires_at).to be_within(1.minute).of(expected)
      end
      it 'returns the expires at from the response if it is more recent than created_at + 7 days' do
        measurement = FactoryBot.create(:measurement, open_duration: 5.days)
        invitation_set = FactoryBot.create(:invitation_set)
        invitation_token = FactoryBot.create(:invitation_token,
                                             invitation_set: invitation_set,
                                             created_at: 3.days.ago)
        FactoryBot.create(:response,
                          open_from: 1.hour.ago,
                          invitation_set: invitation_set,
                          measurement: measurement)
        expected = TimeTools.increase_by_duration(1.hour.ago, measurement.open_duration)
        expect(invitation_token.calculate_expires_at).to be_within(1.minute).of(expected)
      end
      it 'ignores the expires at from the response if it is less than the other two things' do
        measurement = FactoryBot.create(:measurement, open_duration: 2.days)
        invitation_set = FactoryBot.create(:invitation_set)
        invitation_token = FactoryBot.create(:invitation_token,
                                             invitation_set: invitation_set,
                                             created_at: 3.days.ago)
        FactoryBot.create(:response,
                          open_from: 1.hour.ago,
                          invitation_set: invitation_set,
                          measurement: measurement)
        expected = TimeTools.increase_by_duration(invitation_token.created_at,
                                                  described_class::OPEN_TIME_FOR_INVITATION)
        expect(invitation_token.calculate_expires_at).to be_within(1.minute).of(expected)
      end
    end
  end

  describe 'find_attached_responses' do
    it 'uses priority_sorting_metric' do
      person = FactoryBot.create(:person, external_identifier: 'abcd')
      invitation_set = FactoryBot.create(:invitation_set, person: person)
      response = FactoryBot.create(:response, invitation_set: invitation_set)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: invitation_set)
      invitation_token.token = 'efgh'
      invitation_token.save!
      expect_any_instance_of(Response).to receive(:priority_sorting_metric).and_call_original
      expect(described_class.find_attached_responses('abcdefgh')).to eq([response])
    end
  end
end
