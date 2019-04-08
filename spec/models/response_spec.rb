# frozen_string_literal: true

require 'rails_helper'

describe Response do
  it 'should have valid default properties' do
    responseobj = FactoryBot.build(:response)
    expect(responseobj).to be_valid
  end

  it 'should have valid default completed properties' do
    responseobj = FactoryBot.build(:response, :completed)
    expect(responseobj).to be_valid
  end

  describe 'person' do
    it 'should have a person through the protocol subscription' do
      response = FactoryBot.build(:response, :completed)
      result = response.person
      expect(result).to_not be_blank
      expect(result).to eq response.protocol_subscription.person
    end
  end

  context 'scopes' do
    describe 'recently_opened_and_not_invited' do
      it 'should find a response that was opened an hour ago' do
        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 1
      end
      it 'should not find a response that was opened three hours ago' do
        FactoryBot.create(:response, open_from: 3.hours.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'should not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 1.hour.from_now.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'should not find a response that was invited' do
        FactoryBot.create(:response, :invited, open_from: 1.hour.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryBot.create(:response, open_from: 90.minutes.ago.in_time_zone)
        FactoryBot.create(:response, open_from: 60.minutes.ago.in_time_zone)
        FactoryBot.create(:response, open_from: 45.minutes.ago.in_time_zone)
        FactoryBot.create(:response, open_from: 1.minute.from_now.in_time_zone)
        FactoryBot.create(:response, open_from: 121.minutes.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 3
      end
    end
    describe 'opened_and_not_expired' do
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription, start_date: 1.weeks.ago.at_beginning_of_day)
      end

      let(:measurement) do
        FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      end

      it 'should find a response that was opened 9 hours ago' do
        resp = FactoryBot.create(:response, :invited,
                                 open_from: 3.hours.ago.in_time_zone,
                                 measurement: measurement,
                                 protocol_subscription: protocol_subscription)
        expect(resp.protocol_subscription.ended?).to be_falsey
        expect(resp.expired?).to be_falsey
        expect(described_class.opened_and_not_expired.count).to eq 1
      end

      it 'should not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 3.hours.from_now.in_time_zone,
                                     measurement: measurement,
                                     protocol_subscription: protocol_subscription)
        expect(described_class.opened_and_not_expired.count).to eq 0
      end

      it 'should not find a response that is completed' do
        FactoryBot.create(:response, :completed, open_from: 3.hours.from_now.in_time_zone,
                                                 measurement: measurement,
                                                 protocol_subscription: protocol_subscription)
        expect(described_class.opened_and_not_expired.count).to eq 0
      end
      it 'should be able to retrieve multiple responses' do
        FactoryBot.create(:response, :invited,
                          open_from: (Measurement::DEFAULT_REMINDER_DELAY + 90.minutes).ago.in_time_zone,
                          measurement: measurement,
                          protocol_subscription: protocol_subscription)
        FactoryBot.create(:response, :invited,
                          open_from: (Measurement::DEFAULT_REMINDER_DELAY + 60.minutes).ago.in_time_zone,
                          measurement: measurement,
                          protocol_subscription: protocol_subscription)
        FactoryBot.create(:response, :completed,
                          open_from: (Measurement::DEFAULT_REMINDER_DELAY + 50.minutes).ago.in_time_zone,
                          measurement: measurement,
                          protocol_subscription: protocol_subscription)
        FactoryBot.create(:response, :invited,
                          open_from: (Measurement::DEFAULT_REMINDER_DELAY + 45.minutes).ago.in_time_zone,
                          measurement: measurement,
                          protocol_subscription: protocol_subscription)
        FactoryBot.create(:response,
                          open_from: (Measurement::DEFAULT_REMINDER_DELAY + 45.minutes).from_now.in_time_zone,
                          measurement: measurement,
                          protocol_subscription: protocol_subscription)
        expect(described_class.opened_and_not_expired.count).to eq 3
      end
    end
    describe 'completed' do
      it 'should return responses with a completed_at' do
        responseobj = FactoryBot.create(:response, :completed)
        expect(Response.completed.count).to eq 1
        expect(Response.completed.to_a).to eq [responseobj]
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
        responses << FactoryBot.create(:response, :invited)

        expect(Response.invited.count).to eq responses.length
        expect(Response.invited.to_a).to eq responses
      end
      it 'should not return responses for which no invite was sent' do
        responses = FactoryBot.create_list(:response, 10)
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

    describe 'unsubscribe_url' do
      it 'should generate an usubscribe url on the uuid' do
        result = subject.unsubscribe_url
        expected = Rails.application.routes.url_helpers.questionnaire_path(subject.uuid)
        expect(result).to start_with('/questionnaire/')
        expect(result).to end_with(subject.uuid)
        expect(result).to eq expected
      end
    end

    describe 'in_week' do
      it 'should find all responses in the current week and year by default' do
        expected_response = FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 2.weeks.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone)
        result = described_class.in_week
        expect(result.count).to eq 1
        expect(result.first).to eq expected_response
      end
      it 'should find all responses for a given year' do
        Timecop.freeze(2017, 12, 0o6)
        date = Time.zone.now - 2.years
        expected_response = FactoryBot.create(:response, open_from: date)

        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.weeks.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone)
        result = described_class.in_week(year: 2015)
        expect(result.first).to eq expected_response
        expect(result.count).to eq 1
        Timecop.return
      end
      it 'should find all responses for a given week of the year' do
        week_number = 20
        date = Date.commercial(Time.zone.now.year, week_number, 1).in_time_zone + 3.days
        expected_response = FactoryBot.create(:response, open_from: date)

        FactoryBot.create(:response,
                          open_from: Date.commercial(Time.zone.now.year, week_number - 1, 1).in_time_zone + 3.days)

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

  describe 'after_date' do
    it 'should return responses with a open_from that is in the future' do
      FactoryBot.create(:response, open_from: Time.new(2018, 10, 9))
      FactoryBot.create(:response, open_from: Time.new(2018, 10, 10))
      expected = FactoryBot.create(:response, open_from: Time.new(2018, 10, 11))
      thedate = Time.new(2018, 10, 10)
      expect(Response.after_date(thedate).count).to eq 1
      expect(Response.after_date(thedate).to_a).to eq [expected]
    end
  end

  describe 'last?' do
    it 'should return true if this response is the last in the series and false if not' do
      protocol = FactoryBot.create(:protocol, duration: 2.weeks)
      measurement = FactoryBot.create(:measurement, open_duration: 6.hours, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
      responses = (1..10).map do |idx|
        FactoryBot.create(
          :response,
          measurement: measurement,
          open_from: TimeTools.increase_by_duration(protocol_subscription.start_date,
                                                    idx.day + 12.hours),
          protocol_subscription: protocol_subscription
        )
      end

      responses.each_with_index do |response, idx|
        result = response.last?
        expected = (idx == responses.length - 1)
        expect(result).to eq expected
      end
    end
  end

  describe 'remote_content' do
    it 'should work when there is content' do
      responseobj = FactoryBot.create(:response, :completed)
      expect(responseobj.remote_content).to_not be_nil
      expect(responseobj.remote_content).to eq ResponseContent.find(responseobj.content)
    end
    it 'should return nil when there is no content' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.remote_content).to be_nil
    end
  end

  describe 'uuid' do
    it 'should not allow empty external identifiers' do
      responseobj = FactoryBot.build(:response)
      responseobj.uuid = nil
      expect(responseobj).to_not be_valid

      responseobj.uuid = ''
      expect(responseobj).to_not be_valid
    end

    it 'should create an uuid on initialization' do
      responseobj = FactoryBot.build(:response)
      expect(responseobj.uuid).to_not be_blank
      expect(responseobj.uuid.length).to eq 36
    end

    it 'should not allow non-unique identifiers' do
      responseobj = FactoryBot.create(:response)
      response2 = FactoryBot.build(:response, uuid: responseobj.uuid)
      expect(response2).to_not be_valid
      expect(response2.errors.messages).to have_key :uuid
      expect(response2.errors.messages[:uuid]).to include('is al in gebruik')
    end

    it 'should not generate a new uuid if one is already present' do
      uuid = SecureRandom.uuid
      responseobj = FactoryBot.create(:response, uuid: uuid)
      responseobj.reload
      expect(responseobj.uuid).to eq uuid
    end
  end

  describe 'values' do
    it 'should work when there is content' do
      responseobj = FactoryBot.create(:response, :completed)
      expect(responseobj.values).to_not be_nil
      expect(responseobj.values).to eq ResponseContent.find(responseobj.content).content
    end
    it 'should return nil when there is no content' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.values).to be_nil
    end
  end

  describe 'determine_student_mentor' do
    it 'should identify a student response as a response from a student' do
      team = FactoryBot.create(:team)
      student_role = FactoryBot.create(:role, team: team,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, team: team,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role)
      mentor = FactoryBot.create(:mentor, role: mentor_role)

      FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      prot_stud = FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      responseobj = FactoryBot.create(:response, protocol_subscription: prot_stud)
      expect(responseobj.determine_student_mentor).to eq([student, mentor])
    end

    it 'should identify a mentor response as a response from a mentor do' do
      team = FactoryBot.create(:team)
      student_role = FactoryBot.create(:role, team: team,
                                              group: Person::STUDENT, title: Person::STUDENT)
      mentor_role = FactoryBot.create(:role, team: team,
                                             group: Person::MENTOR, title: 'MentorTitle')

      student = FactoryBot.create(:student, role: student_role)
      mentor = FactoryBot.create(:mentor, role: mentor_role)
      prot_ment = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student)
      responseobj = FactoryBot.create(:response, protocol_subscription: prot_ment)
      expect(responseobj.determine_student_mentor).to eq([student, mentor])
    end
  end

  describe 'expires_at' do
    it 'should work for always-open measurements' do
      protocol = FactoryBot.create(:protocol, duration: 2.weeks)
      measurement = FactoryBot.create(:measurement, open_duration: 6.hours, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
      response = FactoryBot.create(:response,
                                   measurement: measurement,
                                   open_from: TimeTools.increase_by_duration(protocol_subscription.start_date,
                                                                             1.day + 12.hours),
                                   protocol_subscription: protocol_subscription)
      expect(response.expires_at).to be_within(1.minute).of(TimeTools.increase_by_duration(response.open_from, 6.hours))
    end
    it 'should work for measurements with an open_duration' do
      protocol = FactoryBot.create(:protocol, duration: 2.weeks)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
      response = FactoryBot.create(:response,
                                   measurement: measurement,
                                   open_from: TimeTools.increase_by_duration(protocol_subscription.start_date,
                                                                             1.day + 12.hours),
                                   protocol_subscription: protocol_subscription)
      expect(response.expires_at).to be_within(1.minute).of(protocol_subscription.end_date)
    end
  end

  describe 'expired?' do
    it 'should return true if the response is no longer open' do
      responseobj = FactoryBot.create(:response, open_from: 3.hours.ago)
      expect(responseobj.expired?).to be_truthy
    end
    it 'should return true if the response has no open_duration but the protocol_subscription has ended' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                                 open_from: 1.day.ago)
      expect(responseobj.expired?).to be_truthy
    end
    it 'should return false if the response has no open_duration but the protocol_subscription has not ended yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                                 open_from: 1.day.ago)
      expect(responseobj.expired?).to be_falsey
    end
    it 'should return false if the response is still open' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
      expect(responseobj.expired?).to be_falsey
    end
    it 'should return false if the response is not open yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryBot.create(:response,
                                      open_from: 1.hour.from_now,
                                      protocol_subscription: protocol_subscription)
      expect(responseobj.expired?).to be_falsey
    end
  end

  describe 'future?' do
    it 'should return true if the response is in the future' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.from_now)
      expect(responseobj.future?).to be_truthy
    end

    it 'should return false if the response is in the past' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj.future?).to be_falsey
    end
  end

  describe 'future_or_current?' do
    it 'should return true if the response is in the future' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.from_now)
      expect(responseobj.future_or_current?).to be_truthy
    end

    it 'should return true if the response is in the past but not expired' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj).to receive(:expired?).and_return(false)
      expect(responseobj.future_or_current?).to be_truthy
    end

    it 'should return false if the response is in the past but and expired' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj).to receive(:expired?).and_return(true)
      expect(responseobj.future_or_current?).to be_falsey
    end
  end

  describe 'protocol_subscription_id' do
    it 'should have one' do
      responseobj = FactoryBot.build(:response, protocol_subscription_id: nil)
      expect(responseobj.valid?).to be_falsey
      expect(responseobj.errors.messages).to have_key :protocol_subscription_id
      expect(responseobj.errors.messages[:protocol_subscription_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a ProtocolSubscription' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.protocol_subscription).to be_a(ProtocolSubscription)
    end
  end

  describe 'measurement_id' do
    it 'should have one' do
      responseobj = FactoryBot.build(:response, measurement_id: nil)
      expect(responseobj.valid?).to be_falsey
      expect(responseobj.errors.messages).to have_key :measurement_id
      expect(responseobj.errors.messages[:measurement_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Measurement' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.measurement).to be_a(Measurement)
    end
  end

  describe 'invitation_set_id' do
    it 'should work to retrieve an InvitationSet' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.invitation_set).to be_an(InvitationSet)
    end
  end

  describe 'content' do
    it 'should accept nil' do
      responseobj = FactoryBot.build(:response, content: nil)
      expect(responseobj.valid?).to be_truthy
    end
    it 'should accept an empty string' do
      responseobj = FactoryBot.build(:response, content: '')
      expect(responseobj.valid?).to be_truthy
    end
    it 'should accept a string' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      given_content = FactoryBot.create(:response_content, content: content_hash)
      responseobj = FactoryBot.create(:response, content: given_content.id)
      responsecontent = ResponseContent.find(responseobj.content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
      response_id = responseobj.id
      responsecontent = ResponseContent.find(Response.find(response_id).content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
    end
  end

  describe 'open_from' do
    it 'should not be nil' do
      responseobj = FactoryBot.build(:response, open_from: nil)
      expect(responseobj.valid?).to be_falsey
      expect(responseobj.errors.messages).to have_key :open_from
      expect(responseobj.errors.messages[:open_from]).to include('moet opgegeven zijn')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
