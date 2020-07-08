# frozen_string_literal: true

require 'rails_helper'

fdescribe SendInvitations do
  describe 'run' do
    let(:default_delay) { Measurement::DEFAULT_REMINDER_DELAY }
    it 'calls the recently_opened_and_not_sent scope' do
      expect(Response).to receive(:recently_opened_and_not_invited).and_return []
      described_class.run
    end

    describe 'loops through responses' do
      it 'queues recent responses' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        expect(responseobj.invitation_set_id).to be_nil
        invitationscount = Invitation.count
        invitationsetscount = InvitationSet.count
        described_class.run
        responseobj.reload
        expect(Invitation.count).to eq(invitationscount + 1) # this person does not have an email
        expect(InvitationSet.count).to eq(invitationsetscount + 1)
        expect(responseobj.invitation_set_id).not_to be_nil
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
      end

      it 'queues two invitations if a person has an email address' do
        student = FactoryBot.create(:person, email: 'student@student.com')
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        expect(responseobj.invitation_set_id).to be_nil
        invitationscount = Invitation.count
        invitationsetscount = InvitationSet.count
        described_class.run
        responseobj.reload
        expect(Invitation.count).to eq(invitationscount + 2) # email and sms
        expect(InvitationSet.count).to eq(invitationsetscount + 1)
        expect(responseobj.invitation_set_id).not_to be_nil
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
      end

      it 'does not queue a response that is outside the recent window' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response,
                                        open_from: (Response::RECENT_PAST + 1.hour).ago,
                                        protocol_subscription: protocol_subscription)
        expect(SendInvitationsJob).not_to receive(:perform_later)
        expect(SendInvitationsJob).not_to receive(:set)
        invitationsetcount = InvitationSet.count
        invitationcount = Invitation.count
        described_class.run
        responseobj.reload
        expect(responseobj.invitation_set_id).to be_nil
        expect(InvitationSet.count).to eq invitationsetcount
        expect(Invitation.count).to eq invitationcount
      end

      it 'does not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  state: ProtocolSubscription::CANCELED_STATE,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationsJob).not_to receive(:perform_later)
        expect(SendInvitationsJob).not_to receive(:set)
        invitationsetcount = InvitationSet.count
        invitationcount = Invitation.count
        described_class.run
        responseobj.reload
        expect(responseobj.invitation_set_id).to be_nil
        expect(InvitationSet.count).to eq invitationsetcount
        expect(Invitation.count).to eq invitationcount
      end

      it 'creates a single invitation_set for multiple responses for mentors' do
        mentor = FactoryBot.create(:mentor)
        responses = Array.new(10) do |_i|
          student = FactoryBot.create(:student)
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    start_date: 1.week.ago.at_beginning_of_day,
                                                    person: mentor, filling_out_for: student)
          responseobj = FactoryBot.create(:response,
                                          open_from: 1.hour.ago,
                                          protocol_subscription: protocol_subscription)
          responseobj
        end
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        invitationsetcount = InvitationSet.count
        invitationcount = Invitation.count
        described_class.run
        expect(InvitationSet.count).to eq(invitationsetcount + 1)
        expect(Invitation.count).to eq(invitationcount + 2)
        responses.each do |resp|
          resp.reload
          expect(resp.invitation_set_id).to eq InvitationSet.first.id
        end
      end

      it 'queues based on the measurement reminder delay time' do
        student = FactoryBot.create(:student)
        reminder_delay = 3.hours + 2.minutes + 1.second
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        measurement = FactoryBot.create(:measurement,
                                        open_duration: 1.day,
                                        reminder_delay: reminder_delay,
                                        protocol: protocol_subscription.protocol)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                   protocol_subscription: protocol_subscription,
                                                   measurement: measurement)

        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: reminder_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        invitationsetscount = InvitationSet.count
        invitationscount = Invitation.count
        described_class.run
        responseobj.reload
        expect(Invitation.count).to eq(invitationscount + 1)
        expect(InvitationSet.count).to eq(invitationsetscount + 1)
        expect(responseobj.invitation_set_id).not_to be_nil
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
      end

      it 'creates a single invitation_set for multiple responses for students' do
        student = FactoryBot.create(:student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        measurement = FactoryBot.create(:measurement,
                                        open_duration: 1.day,
                                        protocol: protocol_subscription.protocol)
        protocol_subscription2 = FactoryBot.create(:protocol_subscription,
                                                   start_date: 2.weeks.ago.at_beginning_of_day,
                                                   person: student)
        measurement2 = FactoryBot.create(:measurement,
                                         open_duration: 1.hour,
                                         protocol: protocol_subscription2.protocol)
        response1 = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 measurement: measurement)
        response2 = FactoryBot.create(:response, open_from: 30.minutes.ago,
                                                 protocol_subscription: protocol_subscription2,
                                                 measurement: measurement2)
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        invitationsetcount = InvitationSet.count
        invitationcount = Invitation.count
        described_class.run
        expect(InvitationSet.count).to eq(invitationsetcount + 1)
        expect(Invitation.count).to eq(invitationcount + 1)
        [response1, response2].each do |resp|
          resp.reload
          expect(resp.invitation_set_id).to eq InvitationSet.first.id
        end
      end
    end

    describe 'reminders' do
      it 'queues reminders for students' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                   protocol_subscription: protocol_subscription,
                                                   measurement: measurement)
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).and_return true
        described_class.run
        responseobj.reload
        expect(InvitationSet.count).to eq 1
        expect(Invitation.count).to eq 1
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
        expect(Invitation.all.map(&:type).sort.uniq).to eq %w[SmsInvitation]
        expect(Invitation.all.map(&:invitation_set_id).sort.uniq).to eq [InvitationSet.first.id]
        expect(InvitationSet.first.person_id).to eq protocol_subscription.person_id
        expect(InvitationSet.first.invitation_tokens).to eq []
        expect(InvitationSet.first.responses.count).to eq 1
      end

      it 'does not queue reminders if reminder delay zero' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol,
                                                      reminder_delay: 0)
        responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                   protocol_subscription: protocol_subscription,
                                                   measurement: measurement)
        expect(SendInvitationsJob).not_to receive(:set)
        expect(SendInvitationsJob).to receive(:perform_later).once.and_return true
        described_class.run
        responseobj.reload
        expect(InvitationSet.count).to eq 1
        expect(Invitation.count).to eq 1
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
        expect(Invitation.all.map(&:type).sort.uniq).to eq %w[SmsInvitation EmailInvitation]
        expect(Invitation.all.map(&:invitation_set_id).sort.uniq).to eq [InvitationSet.first.id]
        expect(InvitationSet.first.person_id).to eq protocol_subscription.person_id
        expect(InvitationSet.first.invitation_tokens).to eq []
        expect(InvitationSet.first.responses.count).to eq 1
      end

      it 'queues reminders for mentor responses' do
        mentor = FactoryBot.create(:mentor)
        protocol_subscription = FactoryBot.create(:protocol_subscription, :mentor,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: mentor)
        expect(protocol_subscription.person_id).not_to eq(protocol_subscription.filling_out_for_id)
        measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        responseobj = FactoryBot.create(:response, open_from: 1.minute.ago,
                                                   protocol_subscription: protocol_subscription,
                                                   measurement: measurement)
        invitationjob = double('sendinvitationsjob')
        expect(invitationjob).to receive(:perform_later).once.and_return true
        expect(SendInvitationsJob).to receive(:set)
          .with(wait: default_delay).once.and_return(invitationjob)
        expect(SendInvitationsJob).to receive(:perform_later).and_return true
        described_class.run
        responseobj.reload
        expect(InvitationSet.count).to eq 1
        expect(responseobj.invitation_set_id).to eq InvitationSet.first.id
        expect(Invitation.all.map(&:type).sort.uniq).to eq %w[SmsInvitation]
        expect(Invitation.all.map(&:invitation_set_id).sort.uniq).to eq [InvitationSet.first.id]
        expect(InvitationSet.first.person_id).to eq protocol_subscription.person_id
        expect(InvitationSet.first.invitation_tokens).to eq []
        expect(InvitationSet.first.responses.count).to eq 1
      end
    end

    it 'does not queue a response that is expired' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: 30.minutes, protocol: protocol_subscription.protocol)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 measurement: measurement)
      expect(SendInvitationsJob).not_to receive(:perform_later)
      expect(SendInvitationsJob).not_to receive(:set)
      invitationsetcount = InvitationSet.count
      invitationcount = Invitation.count
      described_class.run
      responseobj.reload
      expect(responseobj.invitation_set_id).to be_nil
      expect(InvitationSet.count).to eq invitationsetcount
      expect(Invitation.count).to eq invitationcount
    end

    it 'does not queue a response from an inactive protocol subscription' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                state: ProtocolSubscription::CANCELED_STATE)
      measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 measurement: measurement)
      expect(SendInvitationsJob).not_to receive(:perform_later)
      expect(SendInvitationsJob).not_to receive(:set)
      invitationsetcount = InvitationSet.count
      invitationcount = Invitation.count
      described_class.run
      responseobj.reload
      expect(responseobj.invitation_set_id).to be_nil
      expect(InvitationSet.count).to eq invitationsetcount
      expect(Invitation.count).to eq invitationcount
    end

    it 'does not queue responses that people were already invited for' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
      invitation_set = FactoryBot.create(:invitation_set, person: protocol_subscription.person)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 measurement: measurement,
                                                 invitation_set: invitation_set)
      expect(SendInvitationsJob).not_to receive(:perform_later)
      expect(SendInvitationsJob).not_to receive(:set)
      invitationsetcount = InvitationSet.count
      invitationcount = Invitation.count
      expect(responseobj.invitation_set_id).not_to be_nil
      invitationsetidbefore = responseobj.invitation_set_id
      described_class.run
      responseobj.reload
      expect(responseobj.invitation_set_id).not_to be_nil
      expect(responseobj.invitation_set_id).to eq invitationsetidbefore
      expect(InvitationSet.count).to eq invitationsetcount
      expect(Invitation.count).to eq invitationcount
    end

    it 'does not queue responses that have should_invite false measurements' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      measurement = FactoryBot.create(:measurement, should_invite: false, open_duration: 1.day,
                                                    protocol: protocol_subscription.protocol)
      responseobj = FactoryBot.create(:response, open_from: 1.hour.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 measurement: measurement)
      expect(SendInvitationsJob).not_to receive(:perform_later)
      expect(SendInvitationsJob).not_to receive(:set)
      invitationsetcount = InvitationSet.count
      invitationcount = Invitation.count
      described_class.run
      expect(responseobj.invitation_set_id).to be_nil
      expect(InvitationSet.count).to eq invitationsetcount
      expect(Invitation.count).to eq invitationcount
    end
  end
end
