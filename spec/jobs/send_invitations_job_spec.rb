# frozen_string_literal: true

require 'rails_helper'

describe SendInvitationsJob do
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, start_date: Time.zone.now.beginning_of_day) }
  let(:responseobj) do
    FactoryBot.create(:response, :invited,
                      open_from: 10.minutes.ago.in_time_zone,
                      protocol_subscription: protocol_subscription)
  end
  let(:student) { FactoryBot.create(:student) }
  let(:mentor) { FactoryBot.create(:mentor) }

  describe '#perform_later' do
    it 'performs something later' do
      invitation_set = FactoryBot.create(:invitation_set)
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(invitation_set)
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    describe 'when a student is filling out' do
      let(:questionnaire) { FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst') }

      before do
        responseobj.protocol_subscription.update!(person: student)
      end

      it 'schedules an invitation sms' do
        Timecop.freeze(2018, 5, 19) do
          responseobj.measurement = FactoryBot.create(:measurement,
                                                      questionnaire: questionnaire,
                                                      open_duration: nil,
                                                      open_from_offset: 0)
          protocol_subscription.start_date = 10.minutes.ago.beginning_of_day
          protocol_subscription.save!
          responseobj.open_from = 10.minutes.ago.in_time_zone
          responseobj.save!
          FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)

          smstext = 'welkom'
          expect(GenerateInvitationText).to receive(:run!).with(response: responseobj).and_return smstext

          expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
          expect(responseobj.invitation_set.invitation_text).to be_nil
          invcountbefore = Invitation.count
          invtokcountbefore = InvitationToken.count
          invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
          ActiveJob::Base.queue_adapter = :test
          expect do
            subject.perform(responseobj.invitation_set)
          end.to have_enqueued_job(SendInvitationJob).with(instance_of(SmsInvitation), /[a-z0-9]{4}/)
          responseobj.reload
          expect(Invitation.count).to eq invcountbefore
          expect(InvitationToken.count).to eq(1 + invtokcountbefore)
          expect(responseobj.invitation_set.invitation_tokens.count).to eq(1 + invtoksininvsetbefore)
          expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::SENDING_STATE
          expect(responseobj.invitation_set.invitation_text).to eq smstext
        end
      end

      it 'sends reminders with the same text' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation,
                          invitation_set: responseobj.invitation_set,
                          invited_state: Invitation::SENT_STATE)
        FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)

        smstext = 'dont change me'
        responseobj.invitation_set.update!(invitation_text: smstext)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to eq smstext
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.to have_enqueued_job(SendInvitationJob).with(instance_of(SmsInvitation), /[a-z0-9]{4}/)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq(1 + invtokcountbefore)
        expect(responseobj.invitation_set.invitation_tokens.count).to eq(1 + invtoksininvsetbefore)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::SENDING_REMINDER_STATE
        expect(responseobj.invitation_set.invitation_text).to eq smstext
      end

      it 'does not send a reminder if there are no open responses' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation,
                          invitation_set: responseobj.invitation_set,
                          invited_state: Invitation::SENT_STATE)
        FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)

        smstext = 'dont change me'
        responseobj.invitation_set.update!(invitation_text: smstext)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to eq smstext
        responseobj.complete!

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq(invtokcountbefore)
        expect(responseobj.invitation_set.invitation_tokens.count).to eq(invtoksininvsetbefore)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to eq smstext
      end

      it 'does not send an invitation if the response was completed' do
        responseobj.completed_at = 5.minutes.ago
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        expect(GenerateInvitationText).not_to receive(:run!)

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'does not send an invitation if the response was expired' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        expect(GenerateInvitationText).not_to receive(:run!)

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect_any_instance_of(Response).to receive(:expired?).and_return(true)
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'does not send an invitation if the person\'s account is no longer active' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        expect(GenerateInvitationText).not_to receive(:run!)

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        student.update!(account_active: false)
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'does not send an invitation if the measurement should not invite' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        expect(GenerateInvitationText).not_to receive(:run!)

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        responseobj.measurement.update!(should_invite: false)
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'does not send an invitation if the protocol subscription is not active' do
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        expect(GenerateInvitationText).not_to receive(:run!)

        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        responseobj.protocol_subscription.update!(state: ProtocolSubscription::COMPLETED_STATE)
        expect_any_instance_of(Response).to receive(:expired?).and_return(true)
        expect do
          subject.perform(responseobj.invitation_set)
        end.not_to have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end
    end

    describe 'when a mentor is filling out' do
      before do
        responseobj.protocol_subscription.update!(person: mentor)
        # To ensure that it uses the voormeting text (which is check that it is for themselves)
        responseobj.protocol_subscription.update!(filling_out_for_id: mentor.id)
      end

      it 'queues two jobs if there are email_invitations' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'voormeting mentoren')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        protocol_subscription.start_date = 10.minutes.ago.beginning_of_day
        protocol_subscription.save!
        responseobj.open_from = 10.minutes.ago.in_time_zone
        responseobj.save
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        FactoryBot.create(:email_invitation, invitation_set: responseobj.invitation_set)

        smstext = 'welkom mentor'
        expect(GenerateInvitationText).to receive(:run!).with(response: responseobj).and_return smstext
        expect(responseobj.invitation_set.invitations.map(&:invited_state).sort.uniq).to eq [Invitation::NOT_SENT_STATE]
        expect(responseobj.invitation_set.invitation_text).to be_nil
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.to have_enqueued_job(SendInvitationJob).twice.with(kind_of(Invitation), /[a-z0-9]{4}/)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq(1 + invtokcountbefore)
        expect(responseobj.invitation_set.invitation_tokens.count).to eq(1 + invtoksininvsetbefore)
        expect(responseobj.invitation_set.invitations.map(&:invited_state).sort.uniq).to eq [Invitation::SENDING_STATE]
        expect(responseobj.invitation_set.invitation_text).to eq smstext
      end
    end
  end

  describe 'max_attempts' do
    it 'is two' do
      expect(subject.max_attempts).to eq 2
    end
  end

  describe 'reschedule_at' do
    it 'is in one hour' do
      time_now = Time.zone.now
      expect(subject.reschedule_at(time_now, 1)).to be_within(1.minute)
        .of(TimeTools.increase_by_duration(time_now, 1.hour))
    end
  end
end
