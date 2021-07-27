# frozen_string_literal: true

require 'rails_helper'

describe Response do
  it 'has valid default properties' do
    responseobj = FactoryBot.create(:response)
    expect(responseobj).to be_valid
  end

  it 'has valid default completed properties' do
    responseobj = FactoryBot.create(:response, :completed)
    expect(responseobj).to be_valid
  end

  describe 'person' do
    it 'has a person through the protocol subscription' do
      response = FactoryBot.create(:response, :completed)
      result = response.person
      expect(result).not_to be_blank
      expect(result).to eq response.protocol_subscription.person
    end
  end

  context 'scopes' do
    describe 'recently_opened_and_not_invited' do
      it 'finds a response that was opened an hour ago' do
        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 1
      end
      it 'does not find a response that was opened three hours ago' do
        FactoryBot.create(:response, open_from: 3.hours.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'does not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 1.hour.from_now.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'does not find a response that was invited' do
        FactoryBot.create(:response, :invited, open_from: 1.hour.ago.in_time_zone)
        expect(described_class.recently_opened_and_not_invited.count).to eq 0
      end
      it 'is able to retrieve multiple responses' do
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
        FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      end

      let(:measurement) do
        FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      end

      it 'finds a response that was opened 9 hours ago' do
        resp = FactoryBot.create(:response, :invited,
                                 open_from: 3.hours.ago.in_time_zone,
                                 measurement: measurement,
                                 protocol_subscription: protocol_subscription)
        expect(resp.protocol_subscription).not_to be_ended
        expect(resp).not_to be_expired
        expect(described_class.opened_and_not_expired.count).to eq 1
      end

      it 'does not find a response that is not open yet' do
        FactoryBot.create(:response, open_from: 3.hours.from_now.in_time_zone,
                                     measurement: measurement,
                                     protocol_subscription: protocol_subscription)
        expect(described_class.opened_and_not_expired.count).to eq 0
      end

      it 'does not find a response that is completed' do
        FactoryBot.create(:response, :completed, open_from: 3.hours.from_now.in_time_zone,
                                                 measurement: measurement,
                                                 protocol_subscription: protocol_subscription)
        expect(described_class.opened_and_not_expired.count).to eq 0
      end
      it 'is able to retrieve multiple responses' do
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
      it 'returns responses with a completed_at' do
        responseobj = FactoryBot.create(:response, :completed)
        expect(described_class.completed.count).to eq 1
        expect(described_class.completed.to_a).to eq [responseobj]
      end
      it 'does not return responses without a completed at' do
        FactoryBot.create(:response)
        expect(described_class.completed.count).to eq 0
        expect(described_class.completed.to_a).to eq []
      end
    end

    describe 'complete!' do
      it 'it calls the CalculateDistributionJob if this was the first complete' do
        responseobj = FactoryBot.create(:response)
        expect(CalculateDistributionJob).not_to receive(:perform_later)
        expect(UpdateDistributionJob).to receive(:perform_later).once.with(responseobj.id)
        responseobj.complete!
      end
      it 'it calls the UpdateteDistributionJob if this wasn\'t the first complete' do
        responseobj = FactoryBot.create(:response)
        expect(UpdateDistributionJob).to receive(:perform_later).once.with(responseobj.id)
        responseobj.complete!
        expect(CalculateDistributionJob).to receive(:perform_later).once.with(responseobj.id)
        responseobj.complete!
      end
      context 'with push_subscriptions' do
        it 'calls the push_subscriptions_job if it is the first complete' do
          protocol = FactoryBot.create(:protocol)
          protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
          FactoryBot.create(:push_subscription, protocol: protocol)
          measurement = FactoryBot.create(:measurement, protocol: protocol)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          measurement: measurement)
          expect(PushSubscriptionsJob).to receive(:perform_later).once.with(responseobj)
          responseobj.complete!
        end
        it 'doesn\'t call the push_subscriptions_job if it wasn\'t the first complete' do
          protocol = FactoryBot.create(:protocol)
          protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
          FactoryBot.create(:push_subscription, protocol: protocol)
          measurement = FactoryBot.create(:measurement, protocol: protocol)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          measurement: measurement,
                                          completed_at: Time.zone.now)
          expect(PushSubscriptionsJob).not_to receive(:perform_later)
          responseobj.complete!
        end
        it 'doesn\'t call the push_subscriptions_job if there are no push subscriptions' do
          protocol = FactoryBot.create(:protocol)
          protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
          measurement = FactoryBot.create(:measurement, protocol: protocol)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          measurement: measurement)
          expect(PushSubscriptionsJob).not_to receive(:perform_later)
          responseobj.complete!
        end
        it 'doesn\'t call the push_subscriptions_job if csrf_failed' do
          protocol = FactoryBot.create(:protocol)
          protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
          FactoryBot.create(:push_subscription, protocol: protocol)
          measurement = FactoryBot.create(:measurement, protocol: protocol)
          responseobj = FactoryBot.create(:response,
                                          protocol_subscription: protocol_subscription,
                                          measurement: measurement)
          response_content = FactoryBot.create(:response_content,
                                               content: { 'v3' => '68', Response::CSRF_FAILED => 'true' })
          responseobj.content = response_content.id
          responseobj.save!
          expect(PushSubscriptionsJob).not_to receive(:perform_later)
          responseobj.complete!
        end
      end
    end

    describe 'invited' do
      it 'returns responses with a invites that dont have the not_send_state' do
        responses = []
        responses << FactoryBot.create(:response, :completed)
        responses << FactoryBot.create(:response, :invited)

        expect(described_class.invited.count).to eq responses.length
        expect(described_class.invited.to_a).to eq responses
      end
      it 'does not return responses for which no invite was sent' do
        responses = FactoryBot.create_list(:response, 10)
        expect(described_class.all.length).to eq(responses.length)
        expect(described_class.invited.count).to eq 0
        expect(described_class.invited.to_a).to eq []
      end
    end

    describe 'future' do
      it 'returns responses with a open_from that is in the future' do
        future_response = FactoryBot.create(:response, :future)
        expect(described_class.future.count).to eq 1
        expect(described_class.future.to_a).to eq [future_response]
      end
      it 'does not return responses that were in the past' do
        responses = []
        responses << FactoryBot.create(:response, open_from: 1.minute.ago)
        responses << FactoryBot.create(:response, open_from: 2.minutes.ago)
        responses << FactoryBot.create(:response, open_from: 3.years.ago)
        expect(described_class.all.length).to eq(responses.length)
        expect(described_class.future.count).to eq 0
        expect(described_class.future.to_a).to eq []
      end
    end

    describe 'unsubscribe_url' do
      it 'generates an usubscribe url on the uuid' do
        result = subject.unsubscribe_url
        expected = Rails.application.routes.url_helpers.questionnaire_path(subject.uuid)
        expect(result).to start_with('/questionnaire/')
        expect(result).to end_with(subject.uuid)
        expect(result).to eq expected
      end
    end

    describe 'in_week' do
      it 'finds all responses in the current week and year by default' do
        expected_response = FactoryBot.create(:response, open_from: 1.second.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 2.weeks.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone)
        result = described_class.in_week
        expect(result.count).to eq 1
        expect(result.first).to eq expected_response
      end
      it 'finds all responses for a given year' do
        Timecop.freeze(2017, 12, 0o6)
        date = Time.zone.now - 2.years
        expected_response = FactoryBot.create(:response, open_from: date)

        FactoryBot.create(:response, open_from: 1.hour.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.week.ago.in_time_zone)

        FactoryBot.create(:response, open_from: 1.week.from_now.in_time_zone)
        result = described_class.in_week(year: 2015)
        expect(result.first).to eq expected_response
        expect(result.count).to eq 1
        Timecop.return
      end
      it 'finds all responses for a given week of the year' do
        week_number = 20
        date = Date.commercial(Time.zone.now.to_date.cwyear, week_number, 1).in_time_zone + 3.days
        expected_response = FactoryBot.create(:response, open_from: date)

        FactoryBot.create(:response,
                          open_from: Date.commercial(Time.zone.now.to_date.cwyear,
                                                     week_number - 1, 1).in_time_zone + 3.days)

        result = described_class.in_week(week_number: week_number)
        expect(result.count).to eq 1
        expect(result.first).to eq expected_response
      end
      it 'throws whenever unrecognized options are provided' do
        expect { described_class.in_week(week: 1) }
          .to raise_error(RuntimeError, 'Only :week_number and :year are valid options!')
        expect { described_class.in_week(year_number: 2012) }
          .to raise_error(RuntimeError, 'Only :week_number and :year are valid options!')
      end
    end
  end

  describe 'after_date' do
    it 'returns responses with a open_from that is in the future' do
      FactoryBot.create(:response, open_from: Time.zone.local(2018, 10, 9))
      FactoryBot.create(:response, open_from: Time.zone.local(2018, 10, 10))
      expected = FactoryBot.create(:response, open_from: Time.zone.local(2018, 10, 11))
      thedate = Time.zone.local(2018, 10, 10)
      expect(described_class.after_date(thedate).count).to eq 1
      expect(described_class.after_date(thedate).to_a).to eq [expected]
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
    it 'works when there is content' do
      responseobj = FactoryBot.create(:response, :completed)
      expect(responseobj.remote_content).not_to be_nil
      expect(responseobj.remote_content).to eq ResponseContent.find(responseobj.content)
    end
    it 'returns nil when there is no content' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.remote_content).to be_nil
    end
  end

  describe 'uuid' do
    it 'does not allow empty external identifiers' do
      responseobj = FactoryBot.create(:response)
      responseobj.uuid = nil
      expect(responseobj).not_to be_valid

      responseobj.uuid = ''
      expect(responseobj).not_to be_valid
    end

    it 'creates an uuid on initialization' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.uuid).not_to be_blank
      expect(responseobj.uuid.length).to eq 36
    end

    it 'does not allow non-unique identifiers' do
      responseobj = FactoryBot.create(:response)
      response2 = FactoryBot.create(:response)
      response2.uuid = responseobj.uuid
      expect(response2).not_to be_valid
      expect(response2.errors.messages).to have_key :uuid
      expect(response2.errors.messages[:uuid]).to include('is al in gebruik')
    end

    it 'does not generate a new uuid if one is already present' do
      uuid = SecureRandom.uuid
      responseobj = FactoryBot.create(:response, uuid: uuid)
      responseobj.reload
      expect(responseobj.uuid).to eq uuid
    end
  end

  describe 'external_identifiers', focus: true do
    it 'works when there are clones' do
      prot = FactoryBot.create(:protocol, :with_measurements)
      protsub1 = FactoryBot.create(:protocol_subscription, protocol: prot, external_identifier: 'my-ext-1')
      protsub2 = FactoryBot.create(:protocol_subscription, person: protsub1.person, protocol: prot, external_identifier: 'my-ext-2')
      responseobj = FactoryBot.create(:response, :completed, protocol_subscription: protsub1, measurement: prot.measurements[0])
      responseobj2 = FactoryBot.create(:response, :completed, protocol_subscription: protsub2, measurement: prot.measurements[0])
      expect(responseobj.external_identifiers).to match_array(%w[my-ext-1 my-ext-2])
      expect(responseobj2.external_identifiers).to match_array(%w[my-ext-1 my-ext-2])
    end

    it 'does not work when person is different' do
      prot = FactoryBot.create(:protocol, :with_measurements)
      protsub1 = FactoryBot.create(:protocol_subscription, protocol: prot, external_identifier: 'my-ext-1')
      protsub2 = FactoryBot.create(:protocol_subscription, protocol: prot, external_identifier: 'my-ext-2')
      responseobj = FactoryBot.create(:response, :completed, protocol_subscription: protsub1, measurement: prot.measurements[0])
      responseobj2 = FactoryBot.create(:response, :completed, protocol_subscription: protsub2, measurement: prot.measurements[0])
      expect(responseobj.external_identifiers).to match_array(%w[my-ext-1])
      expect(responseobj2.external_identifiers).to match_array(%w[my-ext-2])
    end

    it 'does not work when dates are different is different' do
      prot = FactoryBot.create(:protocol, :with_measurements)
      protsub1 = FactoryBot.create(:protocol_subscription, protocol: prot, external_identifier: 'my-ext-1')
      protsub2 = FactoryBot.create(:protocol_subscription, person: protsub1.person, protocol: prot, external_identifier: 'my-ext-2')
      responseobj = FactoryBot.create(:response, :completed, open_from: Time.zone.now, protocol_subscription: protsub1, measurement: prot.measurements[0])
      responseobj2 = FactoryBot.create(:response, :completed, protocol_subscription: protsub2, measurement: prot.measurements[0])
      expect(responseobj.external_identifiers).to match_array(%w[my-ext-1])
      expect(responseobj2.external_identifiers).to match_array(%w[my-ext-2])
    end
  end

  describe 'values' do
    it 'works when there is content' do
      responseobj = FactoryBot.create(:response, :completed)
      expect(responseobj.values).not_to be_nil
      expect(responseobj.values).to eq ResponseContent.find(responseobj.content).content
    end
    it 'returns nil when there is no content' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.values).to be_nil
    end
  end

  describe 'determine_student_mentor' do
    it 'identifies a student response as a response from a student' do
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

    it 'identifies a mentor response as a response from a mentor do' do
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
    it 'works for always-open measurements' do
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
    it 'works for measurements with an open_duration' do
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
    it 'returns true if the response is no longer open' do
      responseobj = FactoryBot.create(:response, open_from: 3.hours.ago)
      expect(responseobj).to be_expired
    end
    it 'returns true if the response has no open_duration but the protocol_subscription has ended' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 4.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                                 open_from: 1.day.ago)
      expect(responseobj).to be_expired
    end
    it 'returns false if the response has no open_duration but the protocol_subscription has not ended yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 2.weeks.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: nil, protocol: protocol_subscription.protocol)
      # open_from does is not used here
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement,
                                                 open_from: 1.day.ago)
      expect(responseobj).not_to be_expired
    end
    it 'returns false if the response is still open' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
      expect(responseobj).not_to be_expired
    end
    it 'returns false if the response is not open yet' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      responseobj = FactoryBot.create(:response,
                                      open_from: 1.hour.from_now,
                                      protocol_subscription: protocol_subscription)
      expect(responseobj).not_to be_expired
    end
  end

  describe 'future?' do
    it 'returns true if the response is in the future' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.from_now)
      expect(responseobj).to be_future
    end

    it 'returns false if the response is in the past' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj).not_to be_future
    end
  end

  describe 'future_or_current?' do
    it 'returns true if the response is in the future' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.from_now)
      expect(responseobj).to be_future_or_current
    end

    it 'returns true if the response is in the past but not expired' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj).to receive(:expired?).and_return(false)
      expect(responseobj).to be_future_or_current
    end

    it 'returns false if the response is in the past but and expired' do
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago)
      expect(responseobj).to receive(:expired?).and_return(true)
      expect(responseobj).not_to be_future_or_current
    end
  end

  describe 'protocol_subscription_id' do
    it 'has one' do
      responseobj = FactoryBot.create(:response)
      responseobj.protocol_subscription_id = nil
      expect(responseobj).not_to be_valid
      expect(responseobj.errors.messages).to have_key :protocol_subscription_id
      expect(responseobj.errors.messages[:protocol_subscription_id]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a ProtocolSubscription' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.protocol_subscription).to be_a(ProtocolSubscription)
    end
  end

  describe 'measurement_id' do
    it 'has one' do
      responseobj = FactoryBot.create(:response)
      responseobj.measurement_id = nil
      expect(responseobj).not_to be_valid
      expect(responseobj.errors.messages).to have_key :measurement_id
      expect(responseobj.errors.messages[:measurement_id]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a Measurement' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.measurement).to be_a(Measurement)
    end
  end

  describe 'invitation_set_id' do
    it 'works to retrieve an InvitationSet' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.invitation_set).to be_an(InvitationSet)
    end
  end

  describe 'content' do
    it 'accepts nil' do
      responseobj = FactoryBot.create(:response, content: nil)
      expect(responseobj).to be_valid
    end
    it 'accepts an empty string' do
      responseobj = FactoryBot.create(:response, content: '')
      expect(responseobj).to be_valid
    end
    it 'accepts a string' do
      content_hash = { 'v4' => 'goed', 'v5' => ['brood', 'kaas en ham'], 'v6' => 36.2 }
      given_content = FactoryBot.create(:response_content, content: content_hash)
      responseobj = FactoryBot.create(:response, content: given_content.id)
      responsecontent = ResponseContent.find(responseobj.content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
      response_id = responseobj.id
      responsecontent = ResponseContent.find(described_class.find(response_id).content)
      expect(responsecontent.content[:v4]).to eq 'goed'
      expect(responsecontent.content[:v5]).to eq ['brood', 'kaas en ham']
      expect(responsecontent.content[:v6]).to eq 36.2
      expect(responsecontent.content).to eq content_hash
    end
  end

  describe 'open_from' do
    it 'is not nil' do
      responseobj = FactoryBot.create(:response)
      responseobj.open_from = nil
      expect(responseobj).not_to be_valid
      expect(responseobj.errors.messages).to have_key :open_from
      expect(responseobj.errors.messages[:open_from]).to include('moet opgegeven zijn')
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      responseobj = FactoryBot.create(:response)
      expect(responseobj.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'destroy' do
    it 'cleans up response content items' do
      response = FactoryBot.create(:response, :completed)
      expect { response.destroy }.to change(ResponseContent, :count).by(-1)
    end
  end

  describe 'priority_sorting_metric' do
    it 'should sort the responses by descending priority and ascending open_from' do
      measurement4 = FactoryBot.create(:measurement, priority: 2)
      responseobj4 = FactoryBot.create(:response, measurement: measurement4, open_from: 1.day.ago)

      measurement1 = FactoryBot.create(:measurement, priority: 1)
      responseobj1 = FactoryBot.create(:response, measurement: measurement1)

      measurement6 = FactoryBot.create(:measurement, priority: -50)
      responseobj6 = FactoryBot.create(:response, measurement: measurement6)

      measurement2 = FactoryBot.create(:measurement, priority: 0)
      responseobj2 = FactoryBot.create(:response, measurement: measurement2)

      measurement3 = FactoryBot.create(:measurement, priority: 2)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3, open_from: 3.days.ago)

      measurement5 = FactoryBot.create(:measurement, priority: 2)
      responseobj5 = FactoryBot.create(:response, measurement: measurement5, open_from: 2.days.ago)

      responses = [responseobj1, responseobj2, responseobj3, responseobj4, responseobj5, responseobj6]
      expected = [responseobj3, responseobj5, responseobj4, responseobj1, responseobj2, responseobj6]
      expect(responses.sort_by(&:priority_sorting_metric)).to eq(expected)
    end
    it 'should sort items with priority nil after any items with a priority non nil' do
      measurement3 = FactoryBot.create(:measurement, priority: 2)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3, open_from: 2.days.ago)

      measurement5 = FactoryBot.create(:measurement, priority: -20)
      responseobj5 = FactoryBot.create(:response, measurement: measurement5, open_from: 3.days.ago)

      measurement6 = FactoryBot.create(:measurement, priority: nil)
      responseobj6 = FactoryBot.create(:response, measurement: measurement6, open_from: 1.day.ago)

      measurement7 = FactoryBot.create(:measurement, priority: nil)
      responseobj7 = FactoryBot.create(:response, measurement: measurement7, open_from: 2.days.ago)

      responses = [responseobj3, responseobj5, responseobj6, responseobj7]
      expected = [responseobj3, responseobj5, responseobj7, responseobj6]
      expect(responses.sort_by(&:priority_sorting_metric)).to eq(expected)
    end
  end

  describe 'open_from_sorting_metric' do
    it 'should sort the responses by descending priority and ascending open_from' do
      measurement4 = FactoryBot.create(:measurement, priority: 2)
      responseobj4 = FactoryBot.create(:response, measurement: measurement4, open_from: 1.day.ago)

      measurement1 = FactoryBot.create(:measurement, priority: 1)
      responseobj1 = FactoryBot.create(:response, measurement: measurement1)

      measurement6 = FactoryBot.create(:measurement, priority: -50)
      responseobj6 = FactoryBot.create(:response, measurement: measurement6)

      measurement2 = FactoryBot.create(:measurement, priority: 0)
      responseobj2 = FactoryBot.create(:response, measurement: measurement2)

      measurement3 = FactoryBot.create(:measurement, priority: 2)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3, open_from: 3.days.ago)

      measurement5 = FactoryBot.create(:measurement, priority: 2)
      responseobj5 = FactoryBot.create(:response, measurement: measurement5, open_from: 2.days.ago)

      responses = [responseobj1, responseobj2, responseobj3, responseobj4, responseobj5, responseobj6]
      expected = [responseobj1, responseobj2, responseobj6, responseobj3, responseobj5, responseobj4]
      expect(responses.sort_by(&:open_from_sorting_metric)).to eq(expected)
    end
    it 'should sort items with priority nil after any items with a priority non nil' do
      measurement3 = FactoryBot.create(:measurement, priority: 2)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3, open_from: 2.days.ago)

      measurement5 = FactoryBot.create(:measurement, priority: -20)
      responseobj5 = FactoryBot.create(:response, measurement: measurement5, open_from: 3.days.ago)

      measurement6 = FactoryBot.create(:measurement, priority: nil)
      responseobj6 = FactoryBot.create(:response, measurement: measurement6, open_from: 1.day.ago)

      measurement7 = FactoryBot.create(:measurement, priority: nil)
      responseobj7 = FactoryBot.create(:response, measurement: measurement7, open_from: 2.days.ago)

      responses = [responseobj3, responseobj5, responseobj6, responseobj7]
      expected = [responseobj5, responseobj3, responseobj7, responseobj6]
      expect(responses.sort_by(&:open_from_sorting_metric)).to eq(expected)
    end
  end
end
