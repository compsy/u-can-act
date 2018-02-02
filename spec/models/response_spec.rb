# frozen_string_literal: true

require 'rails_helper'

describe Response do
  it 'should have valid default properties' do
    response = FactoryBot.build(:response)
    expect(response).to be_valid
  end

  it 'should have valid default completed properties' do
    response = FactoryBot.build(:response, :completed)
    expect(response).to be_valid
  end

  context 'scopes' do
    describe 'recently_opened_and_not_sent' do
      it 'should find a response that was opened an hour ago' do
        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 1
      end
      it 'should not find a response that was opened three hours ago' do
        FactoryBot.create(:response, open_from: 3.hours.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 1.hour.from_now.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is sending' do
        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone,
                                     invited_state: described_class::SENDING_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should not find a response that is sent' do
        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryBot.create(:response, open_from: 90.minutes.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        FactoryBot.create(:response, open_from: 60.minutes.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        FactoryBot.create(:response, open_from: 45.minutes.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        FactoryBot.create(:response, open_from: 1.minute.from_now.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        FactoryBot.create(:response, open_from: 121.minutes.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.recently_opened_and_not_sent.count).to eq 3
      end
    end
    describe 'still_open_and_not_completed' do
      it 'should find a response that was opened 9 hours ago' do
        FactoryBot.create(:response, open_from: 9.hours.ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 1
      end
      it 'should not find a response that was opened eleven hours ago' do
        FactoryBot.create(:response, open_from: 11.hours.ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 7.hours.ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is sending' do
        FactoryBot.create(:response, open_from: 9.hours.ago.in_time_zone,
                                     invited_state: described_class::SENDING_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is not sent' do
        FactoryBot.create(:response, open_from: 9.hours.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is sending the reminder' do
        FactoryBot.create(:response, open_from: 9.hours.ago.in_time_zone,
                                     invited_state: described_class::SENDING_REMINDER_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that is completed' do
        FactoryBot.create(:response,
                          :completed,
                          open_from: 9.hours.ago.in_time_zone,
                          invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should not find a response that has sent a reminder' do
        FactoryBot.create(:response, open_from: 9.hours.ago.in_time_zone,
                                     invited_state: described_class::REMINDER_SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryBot.create(:response, open_from: (described_class::REMINDER_DELAY + 90.minutes).ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        FactoryBot.create(:response, open_from: (described_class::REMINDER_DELAY + 60.minutes).ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        FactoryBot.create(:response, open_from: (described_class::REMINDER_DELAY + 45.minutes).ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        FactoryBot.create(:response, open_from: (described_class::REMINDER_DELAY - 1.minute).ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        FactoryBot.create(:response, open_from: (described_class::REMINDER_DELAY + 121.minutes).ago.in_time_zone,
                                     invited_state: described_class::SENT_STATE)
        expect(described_class.still_open_and_not_completed.count).to eq 3
      end
    end
    describe 'completed' do
      it 'should return responses with a completed_at' do
        response = FactoryBot.create(:response, :completed)
        expect(Response.completed.count).to eq 1
        expect(Response.completed.to_a).to eq [response]
      end
      it 'should not return responses without a completed at' do
        FactoryBot.create(:response)
        expect(Response.completed.count).to eq 0
        expect(Response.completed.to_a).to eq []
      end
    end
    describe 'invited' do
      it 'should return responses with a invites that dont have the not_send_state' do
        responses = []
        responses << FactoryBot.create(:response, :completed)
        responses << FactoryBot.create(:response, invited_state: described_class::SENT_STATE)
        responses << FactoryBot.create(:response, invited_state: described_class::REMINDER_SENT_STATE)
        responses << FactoryBot.create(:response, invited_state: described_class::SENDING_REMINDER_STATE)

        expect(Response.invited.count).to eq responses.length
        expect(Response.invited.to_a).to eq responses
      end
      it 'should not return responses for which no invite was sent' do
        responses = FactoryBot.create_list(:response, 10, invited_state: described_class::NOT_SENT_STATE)
        responses << FactoryBot.create(:response, invited_state: described_class::SENDING_STATE)
        expect(Response.all.length).to eq(responses.length)
        expect(Response.invited.count).to eq 0
        expect(Response.invited.to_a).to eq []
      end
    end

    describe 'future' do
      it 'should return responses with a open_from that is in the future' do
        future_response = FactoryBot.create(:response, :future)
        expect(Response.future.count).to eq 1
        expect(Response.future.to_a).to eq [future_response]
      end
      it 'should not return responses that were in the past' do
        responses = []
        responses << FactoryBot.create(:response, open_from: 1.minute.ago)
        responses << FactoryBot.create(:response, open_from: 2.minutes.ago)
        responses << FactoryBot.create(:response, open_from: 3.years.ago)
        expect(Response.all.length).to eq(responses.length)
        expect(Response.future.count).to eq 0
        expect(Response.future.to_a).to eq []
      end
    end

    describe 'in_week' do
      it 'should find all responses in the current week and year by default' do
        expected_response = FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone,
                                                         invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 2.weeks.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        result = described_class.in_week
        expect(result.count).to eq 1
        expect(result.first).to eq expected_response
      end
      it 'should find all responses for a given year' do
        Timecop.freeze(2017, 12, 0o6)
        date = Time.zone.now - 2.years
        expected_response = FactoryBot.create(:response, open_from: date,
                                                         invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 1.weeks.ago.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)
        result = described_class.in_week(year: 2015)
        expect(result.first).to eq expected_response
        expect(result.count).to eq 1
        Timecop.return
      end
      it 'should find all responses for a given week of the year' do
        week_number = 20
        date = Date.commercial(Time.zone.now.year, week_number, 1).in_time_zone + 3.days
        expected_response = FactoryBot.create(:response, open_from: date,
                                                         invited_state: described_class::NOT_SENT_STATE)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone,
                                     invited_state: described_class::NOT_SENT_STATE)

        result = described_class.in_week(week_number: week_number)
        expect(result.count).to eq 1
        expect(result.first).to eq expected_response
      end
      it 'should throw whenever unrecognized options are provided' do
        expect { described_class.in_week(week: 1) }
          .to raise_error(RuntimeError, 'Only :week_number and :year are valid options!')
        expect { described_class.in_week(year_number: 2012) }
          .to raise_error(RuntimeError, 'Only :week_number and :year are valid options!')
      end
    end
  end

  describe 'remote_content' do
    it 'should work when there is content' do
      response = FactoryBot.create(:response, :completed)
      expect(response.remote_content).to_not be_nil
      expect(response.remote_content).to eq ResponseContent.find(response.content)
    end
    it 'should return nil when there is no content' do
      response = FactoryBot.create(:response)
      expect(response.remote_content).to be_nil
    end
  end

  describe 'uuid' do
    it 'should not allow empty external identifiers' do
      response = FactoryBot.build(:response)
      response.uuid = nil
      expect(response).to_not be_valid

      response.uuid = ''
      expect(response).to_not be_valid
    end

    it 'should create an uuid on initialization' do
      response = FactoryBot.build(:response)
      expect(response.uuid).to_not be_blank
      expect(response.uuid.length).to eq 36
    end

    it 'should not allow non-unique identifiers' do
      response = FactoryBot.create(:response)
      response2 = FactoryBot.build(:response, uuid: response.uuid)
      expect(response2).to_not be_valid
      expect(response2.errors.messages).to have_key :uuid
      expect(response2.errors.messages[:uuid]).to include('is al in gebruik')
    end

    it 'should not generate a new uuid if one is already present' do
      uuid = SecureRandom.uuid
      response = FactoryBot.create(:response, uuid: uuid)
      response.reload
      expect(response.uuid).to eq uuid
    end
  end

  describe 'values' do
    it 'should work when there is content' do
      response = FactoryBot.create(:response, :completed)
      expect(response.values).to_not be_nil
      expect(response.values).to eq ResponseContent.find(response.content).content
    end
    it 'should return nil when there is no content' do
      response = FactoryBot.create(:response)
      expect(response.values).to be_nil
    end
  end

  describe 'determine_student_mentor' do
    it 'should identify a student response as a response from a student' do
      organization = FactoryBot.create(:organization)
      student_role = FactoryBot.create(:role, organization: organization,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, organization: organization,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role)
      mentor = FactoryBot.create(:mentor, role: mentor_role)

      FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      prot_stud = FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryBot.create(:response, protocol_subscription: prot_stud)
      expect(response.determine_student_mentor).to eq([student, mentor])
    end

    it 'should identify a mentor response as a response from a mentor do' do
      organization = FactoryBot.create(:organization)
      student_role = FactoryBot.create(:role, organization: organization,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, organization: organization,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role)
      mentor = FactoryBot.create(:mentor, role: mentor_role)
      prot_ment = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryBot.create(:response, protocol_subscription: prot_ment)
      expect(response.determine_student_mentor).to eq([student, mentor])
    end
  end

  describe 'substitute_variables' do
    it 'should replace variables in a student response' do
      organization = FactoryBot.create(:organization)
      student_role = FactoryBot.create(:role, organization: organization,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, organization: organization,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role, first_name: 'Emma', gender: Person::FEMALE)
      mentor = FactoryBot.create(:mentor, role: mentor_role, first_name: 'Pieter', gender: Person::MALE)

      FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      prot_stud = FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryBot.create(:response, protocol_subscription: prot_stud)

      subtext = 'Hoi {{deze_student}} {{hij_zij_student}} {{naam_begeleider}} {{hem_haar_begeleider}}'
      expect(response.substitute_variables(subtext)).to eq 'Hoi Emma zij Pieter hem'
    end

    it 'should replace variables in a mentor response' do
      organization = FactoryBot.create(:organization)
      student_role = FactoryBot.create(:role, organization: organization,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, organization: organization,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role, first_name: 'Emma', gender: Person::FEMALE)
      mentor = FactoryBot.create(:mentor, role: mentor_role, first_name: 'Pieter', gender: Person::MALE)
      prot_ment = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      response = FactoryBot.create(:response, protocol_subscription: prot_ment)

      subtext = 'Hoi {{deze_student}} {{hij_zij_student}} {{naam_begeleider}} {{hem_haar_begeleider}}'
      expect(response.substitute_variables(subtext)).to eq 'Hoi Emma zij Pieter hem'
    end
  end

  describe 'expired?' do
    it 'should return true if the response is no longer open' do
      response = FactoryBot.create(:response, open_from: 3.hours.ago)
      expect(response.expired?).to be_truthy
    end
    it 'should return true if the response has no open_duration but the protocol_subscription has ended' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                              open_from: 1.day.ago)
      expect(response.expired?).to be_truthy
    end
    it 'should return false if the response has no open_duration but the protocol_subscription has not ended yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                              open_from: 1.day.ago)
      expect(response.expired?).to be_falsey
    end
    it 'should return false if the response is still open' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      response = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
      expect(response.expired?).to be_falsey
    end
    it 'should return false if the response is not open yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      response = FactoryBot.create(:response, open_from: 1.hour.from_now, protocol_subscription: protocol_subscription)
      expect(response.expired?).to be_falsey
    end
  end

  describe 'future?' do
    it 'should return true if the response is in the future' do
      response = FactoryBot.create(:response, open_from: 1.hour.from_now)
      expect(response.future?).to be_truthy
    end

    it 'should return false if the response is in the past' do
      response = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(response.future?).to be_falsey
    end
  end

  describe 'protocol_subscription_id' do
    it 'should have one' do
      response = FactoryBot.build(:response, protocol_subscription_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :protocol_subscription_id
      expect(response.errors.messages[:protocol_subscription_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a ProtocolSubscription' do
      response = FactoryBot.create(:response)
      expect(response.protocol_subscription).to be_a(ProtocolSubscription)
    end
  end

  describe 'measurement_id' do
    it 'should have one' do
      response = FactoryBot.build(:response, measurement_id: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :measurement_id
      expect(response.errors.messages[:measurement_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Measurement' do
      response = FactoryBot.create(:response)
      expect(response.measurement).to be_a(Measurement)
    end
  end

  describe 'initialize_response!' do
    let(:response) { FactoryBot.create(:response) }
    it 'should create an invitation token' do
      expect(response.invitation_token).to be_nil
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token_plain).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
    end
    it 'should reuse the same token if one already exists' do
      FactoryBot.create(:invitation_token, response: response)
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token_plain).to_not be_nil
      current_token = response.invitation_token.token_plain
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
      expect(response.invitation_token.token_plain).to_not be_nil
      expect(response.invitation_token.token_plain).to eq current_token
    end
    it 'should update the created_at when reusing a token' do
      FactoryBot.create(:invitation_token, response: response, created_at: 3.days.ago)
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.created_at).to be_within(5.minutes).of(3.days.ago)
      current_token = response.invitation_token.token_plain
      response.initialize_invitation_token!
      expect(response.invitation_token).to_not be_nil
      expect(response.invitation_token.token).to_not be_nil
      expect(response.invitation_token.token_plain).to_not be_nil
      expect(response.invitation_token.token_plain).to eq current_token
      expect(response.invitation_token.created_at).to be_within(5.minutes).of(Time.zone.now)
    end
  end

  describe 'content' do
    it 'should accept nil' do
      response = FactoryBot.build(:response, content: nil)
      expect(response.valid?).to be_truthy
    end
    it 'should accept an empty string' do
      response = FactoryBot.build(:response, content: '')
      expect(response.valid?).to be_truthy
    end
    it 'should accept a string' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      given_content = FactoryBot.create(:response_content, content: content_hash)
      response = FactoryBot.create(:response, content: given_content.id)
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
      response = FactoryBot.build(:response, open_from: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :open_from
      expect(response.errors.messages[:open_from]).to include('moet opgegeven zijn')
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      response = FactoryBot.build(:response)
      response.invited_state = Response::NOT_SENT_STATE
      expect(response.valid?).to be_truthy
      response = FactoryBot.build(:response)
      response.invited_state = Response::SENDING_STATE
      expect(response.valid?).to be_truthy
      response = FactoryBot.build(:response)
      response.invited_state = Response::SENT_STATE
      expect(response.valid?).to be_truthy
    end
    it 'should not be nil' do
      response = FactoryBot.build(:response, invited_state: nil)
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      response = FactoryBot.build(:response, invited_state: '')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      response = FactoryBot.build(:response, invited_state: 'somestring')
      expect(response.valid?).to be_falsey
      expect(response.errors.messages).to have_key :invited_state
      expect(response.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'invitation_token' do
    it 'should destroy the invitation_token when destroying the response' do
      response = FactoryBot.create(:response)
      FactoryBot.create(:invitation_token, response: response)
      expect(response.invitation_token).to be_a(InvitationToken)
      invtokencountbefore = InvitationToken.count
      response.destroy
      expect(InvitationToken.count).to eq(invtokencountbefore - 1)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      response = FactoryBot.create(:response)
      expect(response.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(response.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'find_by_identifier' do
    let(:other_person) { FactoryBot.create(:person) }

    let(:response) { FactoryBot.create(:response, :invite_sent) }
    let(:token) { FactoryBot.create(:invitation_token, response: response) }

    let(:not_sent_response) { FactoryBot.create(:response) }
    let(:not_sent_token) { FactoryBot.create(:invitation_token, response: not_sent_response) }

    it 'should return nil if there is no person with that identifier' do
      result = Response.find_by_identifier('non_existent', token.token_plain)
      expect(result).to be_nil
    end

    it 'should return nil if the person has no responses' do
      result = Response.find_by_identifier(other_person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'should return nil if the token does not match any of the responses ' do
      person = response.protocol_subscription.person
      result = Response.find_by_identifier(person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'should return nil if the token matches an unsent response' do
      person = response.protocol_subscription.person
      result = Response.find_by_identifier(person.external_identifier, not_sent_token.token_plain)
      expect(result).to be_nil
    end

    it 'should return nil if there is one that matches the description but the hashed token is provided' do
      person = response.protocol_subscription.person
      result = Response.find_by_identifier(person.external_identifier, token.token)
      expect(result).to be_nil
    end

    it 'should return the response if there is one that matches the description' do
      person = response.protocol_subscription.person
      result = Response.find_by_identifier(person.external_identifier, token.token_plain)
      expect(result).to eq response
    end

    it 'should return the response if there is one that matches the description and is completed' do
      response.update_attributes!(completed_at: Time.zone.now)
      person = response.protocol_subscription.person
      result = Response.find_by_identifier(person.external_identifier, token.token_plain)
      expect(result).to eq response
    end
  end

  describe 'invitation_url' do
    it 'should return the correct invitation_url for a response' do
      response = FactoryBot.create(:response)
      token = FactoryBot.create(:invitation_token, response: response)
      pt_token = token.token_plain
      expect(response.invitation_token.token_plain).to_not be_blank
      result = response.invitation_url
      expect(result).to match pt_token
      expect(result).to_not match token.token_hash
      expect(result).to match response.protocol_subscription.person.external_identifier
      expect(result).to eq "#{ENV['HOST_URL']}"\
        "?q=#{response.protocol_subscription.person.external_identifier}#{pt_token}"
    end

    it 'should raise if called for a previously stored token' do
      response = FactoryBot.create(:response)
      FactoryBot.create(:invitation_token, response: response)
      response.reload
      expect(response.invitation_token).to_not be_blank
      expect(response.invitation_token.token_plain).to be_blank
      expect { response.invitation_url }
        .to raise_error(RuntimeError, 'Cannot generate invitation_url for historical invitation tokens!')
    end
  end
end
