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
    describe 'still_open_and_not_completed' do
      it 'should find a response that was opened 9 hours ago' do
        FactoryGirl.create(:response, open_from: 9.hours.ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 1
      end
      it 'should not find a response that was opened eleven hours ago' do
        FactoryGirl.create(:response, open_from: 11.hours.ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is not open yet' do
        FactoryGirl.create(:response, open_from: 7.hours.ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is sending' do
        FactoryGirl.create(:response, open_from: 9.hours.ago.in_time_zone,
                                      invited_state: described_class::SENDING_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is not sent' do
        FactoryGirl.create(:response, open_from: 9.hours.ago.in_time_zone,
                                      invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is sending the reminder' do
        FactoryGirl.create(:response, open_from: 9.hours.ago.in_time_zone,
                                      invited_state: described_class::SENDING_REMINDER_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is completed' do
        FactoryGirl.create(:response,
                           :completed,
                           open_from: 9.hours.ago.in_time_zone,
                           invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that has sent a reminder' do
        FactoryGirl.create(:response, open_from: 9.hours.ago.in_time_zone,
                                      invited_state: described_class::REMINDER_SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryGirl.create(:response, open_from: (described_class::REMINDER_DELAY + 90.minutes).ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        FactoryGirl.create(:response, open_from: (described_class::REMINDER_DELAY + 60.minutes).ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        FactoryGirl.create(:response, open_from: (described_class::REMINDER_DELAY + 45.minutes).ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        FactoryGirl.create(:response, open_from: (described_class::REMINDER_DELAY - 1.minute).ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        FactoryGirl.create(:response, open_from: (described_class::REMINDER_DELAY + 121.minutes).ago.in_time_zone,
                                      invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 3
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
    describe 'invited' do
      it 'should return responses with a invites that dont have the not_send_state' do
        responses = []
        responses << FactoryGirl.create(:response, :completed)
        responses << FactoryGirl.create(:response, invited_state: described_class::SENT_STATE)
        responses << FactoryGirl.create(:response, invited_state: described_class::REMINDER_SENT_STATE)
        responses << FactoryGirl.create(:response, invited_state: described_class::SENDING_REMINDER_STATE)

        expect(Response.invited.count).to eq responses.length
        expect(Response.invited.to_a).to eq responses
      end
      it 'should not return responses for which no invite was sent' do
        responses = FactoryGirl.create_list(:response, 10, invited_state: described_class::NOT_SENT_STATE)
        responses << FactoryGirl.create(:response, invited_state: described_class::SENDING_STATE)
        expect(Response.all.length).to eq(responses.length)
        expect(Response.invited.count).to eq 0
        expect(Response.invited.to_a).to eq []
      end
    end
  end

  describe 'remote_content' do
    it 'should work when there is content' do
      response = FactoryGirl.create(:response, :completed)
      expect(response.remote_content).to_not be_nil
      expect(response.remote_content).to eq ResponseContent.find(response.content)
    end
    it 'should return nil when there is no content' do
      response = FactoryGirl.create(:response)
      expect(response.remote_content).to be_nil
    end
  end

  describe 'values' do
    it 'should work when there is content' do
      response = FactoryGirl.create(:response, :completed)
      expect(response.values).to_not be_nil
      expect(response.values).to eq ResponseContent.find(response.content).content
    end
    it 'should return nil when there is no content' do
      response = FactoryGirl.create(:response)
      expect(response.values).to be_nil
    end
  end

  describe 'determine_student_mentor' do
    it 'should identify a student response as a response from a student' do
      organization = FactoryGirl.create(:organization)
      student = FactoryGirl.create(:student, organization: organization)
      mentor = FactoryGirl.create(:mentor, organization: organization)
      FactoryGirl.create(:protocol_subscription, person: mentor, filling_out_for: student)
      prot_stud = FactoryGirl.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryGirl.create(:response, protocol_subscription: prot_stud)
      expect(response.determine_student_mentor).to eq([student, mentor])
    end
    it 'should identify a mentor response as a response from a mentor do' do
      organization = FactoryGirl.create(:organization)
      student = FactoryGirl.create(:student, organization: organization)
      mentor = FactoryGirl.create(:mentor, organization: organization)
      prot_ment = FactoryGirl.create(:protocol_subscription, person: mentor, filling_out_for: student)
      FactoryGirl.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryGirl.create(:response, protocol_subscription: prot_ment)
      expect(response.determine_student_mentor).to eq([student, mentor])
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

  describe 'initialize_response!' do
    let(:response) { FactoryGirl.create(:response) }
    it 'should create an invitation token' do
      expect(response.invitation_token).to be_nil
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
    end
    it 'should reuse the same token if one already exists' do
      FactoryGirl.create(:invitation_token, response: response)
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
      current_token = response.invitation_token.token
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
      expect(response.invitation_token.token).to eq current_token
    end
    it 'should update the created_at when reusing a token' do
      FactoryGirl.create(:invitation_token, response: response, created_at: 3.days.ago)
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.created_at).to be_within(5.minutes).of(3.days.ago)
      current_token = response.invitation_token.token
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
      expect(response.invitation_token.token).to eq current_token
      expect(response.invitation_token.created_at).to be_within(5.minutes).of(Time.zone.now)
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
