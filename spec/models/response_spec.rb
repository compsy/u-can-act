# frozen_string_literal: true

require 'rails_helper'

describe Response do
  it 'should have valid default properties' do
    response = FactoryGirl.build(:response)
    expect(response.valid?).to be_truthy
  end

  it 'should have valid default completed properties' do
    response = FactoryGirl.build(:response, :completed)
    expect(response.valid?).to be_truthy
  end

  context 'scopes' do
    describe 'recently_opened_and_not_sent' do
      it 'should find a response that was opened an hour ago' do
        FactoryGirl.create(:response, open_from: 1.hour.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 1
      end
      it 'should not find a response that was opened three hours ago' do
        FactoryGirl.create(:response, open_from: 3.hours.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is not open yet' do
        FactoryGirl.create(:response, open_from: 1.hour.from_now.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is sending' do
        FactoryGirl.create(:response, open_from: 1.hour.ago.in_time_zone,
                                      invited_state: described_class::SENDING_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is sent' do
        FactoryGirl.create(:response, open_from: 1.hour.ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryGirl.create(:response, open_from: 90.minutes.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        FactoryGirl.create(:response, open_from: 60.minutes.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        FactoryGirl.create(:response, open_from: 45.minutes.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        FactoryGirl.create(:response, open_from: 1.minute.from_now.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        FactoryGirl.create(:response, open_from: 121.minutes.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 3
      end
    end
    describe 'completed' do
      it 'should return responses with a completed_at' do
        response = FactoryGirl.create(:response, :completed)
        expect(Response.completed.count).to eq 1
        expect(Response.completed.to_a).to eq [response]
      end
      it 'should not return responses without a completed at' do
        FactoryGirl.create(:response)
        expect(Response.completed.count).to eq 0
        expect(Response.completed.to_a).to eq []
      end
    end
    describe 'invite_sent' do
      it 'should return responses with a sent invite' do
        response = FactoryGirl.create(:response, :completed)
        responsetwo = FactoryGirl.create(:response, invited_state: described_class::SENT_STATE)
        expect(Response.invite_sent.count).to eq 2
        expect(Response.invite_sent.to_a).to eq [response, responsetwo]
      end
      it 'should not return responses for which no invite was sent' do
        FactoryGirl.create(:response)
        expect(Response.invite_sent.count).to eq 0
        expect(Response.invite_sent.to_a).to eq []
      end
    end
  end

  describe 'expired?' do
    it 'should return true if the response is no longer open' do
      response = FactoryGirl.create(:response, open_from: 3.hours.ago)
      expect(response.expired?).to be_truthy
    end
    it 'should return true if the response has no open_duration but the protocol_subscription has ended' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
      measurement = FactoryGirl.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      response = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                               open_from: 1.day.ago)
      expect(response.expired?).to be_truthy
    end
    it 'should return false if the response has no open_duration but the protocol_subscription has not ended yet' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
      measurement = FactoryGirl.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      response = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                               open_from: 1.day.ago)
      expect(response.expired?).to be_falsey
    end
    it 'should return false if the response is still open' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      response = FactoryGirl.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
      expect(response.expired?).to be_falsey
    end
    it 'should return false if the response is not open yet' do
      protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      response = FactoryGirl.create(:response, open_from: 1.hour.from_now, protocol_subscription: protocol_subscription)
      expect(response.expired?).to be_falsey
    end
  end

  describe 'protocol_subscription_id' do
    it 'should have one' do
      response = FactoryGirl.build(:response, protocol_subscription_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :protocol_subscription_id
      expect(response.errors.messages[:protocol_subscription_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a ProtocolSubscription' do
      response = FactoryGirl.create(:response)
      expect(response.protocol_subscription).to be_a(ProtocolSubscription)
    end
  end

  describe 'measurement_id' do
    it 'should have one' do
      response = FactoryGirl.build(:response, measurement_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :measurement_id
      expect(response.errors.messages[:measurement_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Measurement' do
      response = FactoryGirl.create(:response)
      expect(response.measurement).to be_a(Measurement)
    end
  end

  describe 'content' do
    it 'should accept nil' do
      response = FactoryGirl.build(:response, content: nil)
      expect(response.valid?).to be_truthy
    end
    it 'should accept an empty string' do
      response = FactoryGirl.build(:response, content: '')
      expect(response.valid?).to be_truthy
    end
    it 'should accept a string' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      given_content = FactoryGirl.create(:response_content, content: content_hash)
      response = FactoryGirl.create(:response, content: given_content.id)
      responsecontent = ResponseContent.find(response.content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
      response_id = response.id
      responsecontent = ResponseContent.find(Response.find(response_id).content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
    end
  end

  describe 'open_from' do
    it 'should not be nil' do
      response = FactoryGirl.build(:response, open_from: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :open_from
      expect(response.errors.messages[:open_from]).to include('moet opgegeven zijn')
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      response = FactoryGirl.build(:response)
      response.invited_state = Response::NOT_SENT_STATE
      expect(response.valid?).to be_truthy
      response = FactoryGirl.build(:response)
      response.invited_state = Response::SENDING_STATE
      expect(response.valid?).to be_truthy
      response = FactoryGirl.build(:response)
      response.invited_state = Response::SENT_STATE
      expect(response.valid?).to be_truthy
    end
    it 'should not be nil' do
      response = FactoryGirl.build(:response, invited_state: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      response = FactoryGirl.build(:response, invited_state: '')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      response = FactoryGirl.build(:response, invited_state: 'somestring')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'invitation_token' do
    it 'should destroy the invitation_token when destroying the response' do
      response = FactoryGirl.create(:response)
      FactoryGirl.create(:invitation_token, response: response)
      expect(response.invitation_token).to be_a(InvitationToken)
      invtokencountbefore = InvitationToken.count
      response.destroy
      expect(InvitationToken.count).to eq(invtokencountbefore - 1)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      response = FactoryGirl.create(:response)
      expect(response.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(response.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
