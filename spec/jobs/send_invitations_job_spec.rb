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
      before :each do
        responseobj.protocol_subscription.update_attributes!(person: student)
      end

      it 'should send the voormeting sms whenever the questionnaire is a voormeting and the person is a student' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)

        smstext = "Welkom bij de kick-off van het onderzoek 'u-can-act'. Fijn " \
        'dat je meedoet! Vandaag starten we met een aantal korte vragen, morgen ' \
        'begint de wekelijkse vragenlijst. Via de link kom je bij de vragen en ' \
        'een filmpje met meer info over u-can-act. Succes!'

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

      it 'should send the repeated voormeting sms when the questionnaire is a voormeting and the person is a student' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        FactoryBot.create(:response, :completed, protocol_subscription: responseobj.protocol_subscription,
                                                 open_from: 1.second.ago)

        smstext = 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze week ' \
        'ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ingevuld. ' \
        'Je beloning loopt gewoon door natuurlijk!'

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

      it 'should send reminders voor for students' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation,
                          invitation_set: responseobj.invitation_set,
                          invited_state: Invitation::SENT_STATE)
        FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        smstext = 'dont change me'
        responseobj.invitation_set.update_attributes!(invitation_text: smstext)
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

      it 'should not send an invitation if the response was completed' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        responseobj.completed_at = 5.minutes.ago
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.to_not have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'should not send an invitation if the response was expired' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect_any_instance_of(Response).to receive(:expired?).and_return(true)
        expect do
          subject.perform(responseobj.invitation_set)
        end.to_not have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'should send the first text if the questionnaire is not a voormeting and it is the first one' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryBot.create(:questionnaire, name: 'voormeting')
        measurement = FactoryBot.create(:measurement, questionnaire: voormeting)
        FactoryBot.create(:response, :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 48.hours.ago,
                          completed_at: 10.hours.ago,
                          measurement: measurement)

        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek, open_duration: 36.hours)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 24.hour.ago,
                                        measurement: measurement)
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)

        smstext = 'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'

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

      it 'should send the second text if the questionnaire is not a voormeting and it is not the first one' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryBot.create(:questionnaire, name: 'voormeting')
        measurement = FactoryBot.create(:measurement, questionnaire: voormeting)
        FactoryBot.create(:response, :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 48.hours.ago,
                          completed_at: 10.hours.ago,
                          measurement: measurement)

        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, :periodical, questionnaire: dagboek, open_duration: 36.hours)
        FactoryBot.create(:response, :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 24.hours.ago,
                          completed_at: 10.hours.ago,
                          measurement: measurement)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 24.hours.ago,
                                        measurement: measurement)
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)

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
        expect(responseobj.invitation_set.invitation_text).to_not be_nil
      end
    end

    describe 'when a mentor is filling out' do
      before :each do
        responseobj.protocol_subscription.update_attributes!(person: mentor)
        # To ensure that it uses the voormeting text (which is check that it is for themselves)
        responseobj.protocol_subscription.update_attributes!(filling_out_for_id: mentor.id)
      end

      it 'should send the initial text with the voormeting questionnaire' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'voormeting mentoren')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)

        smstext = "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
        'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
        'Morgen start de eerste wekelijkse vragenlijst. Succes!'
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

      it 'should send a repeated text with the repeated voormeting questionnaire text' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'voormeting mentoren')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        FactoryBot.create(:response, :completed, protocol_subscription: responseobj.protocol_subscription)

        smstext = 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze ' \
      'week ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ' \
      'ingevuld. Na het invullen hiervan kom je weer bij de wekelijkse vragenlijst.'
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

      it 'should queue two jobs if there are email_invitations' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'voormeting mentoren')
        responseobj.measurement = FactoryBot.create(:measurement,
                                                    questionnaire: questionnaire,
                                                    open_duration: nil,
                                                    open_from_offset: 0)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        FactoryBot.create(:email_invitation, invitation_set: responseobj.invitation_set)

        smstext = "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
        'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
        'Morgen start de eerste wekelijkse vragenlijst. Succes!'
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

      it 'should send reminders for mentors' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'Mentoren voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        FactoryBot.create(:sms_invitation,
                          invitation_set: responseobj.invitation_set,
                          invited_state: Invitation::SENT_STATE)
        smstext = 'dont change me'
        responseobj.invitation_set.update_attributes!(invitation_text: smstext)
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

      it 'should not send an invitation if the response was completed' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'Mentoren voormeting vragenlijst')
        responseobj.completed_at = 5.minutes.ago
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect do
          subject.perform(responseobj.invitation_set)
        end.to_not have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'should not send an invitation if the response was expired' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'Mentoren voormeting vragenlijst')
        responseobj.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        responseobj.save!
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
        invcountbefore = Invitation.count
        invtokcountbefore = InvitationToken.count
        invtoksininvsetbefore = responseobj.invitation_set.invitation_tokens.count
        ActiveJob::Base.queue_adapter = :test
        expect_any_instance_of(Response).to receive(:expired?).and_return(true)
        expect do
          subject.perform(responseobj.invitation_set)
        end.to_not have_enqueued_job(SendInvitationJob)
        responseobj.reload
        expect(Invitation.count).to eq invcountbefore
        expect(InvitationToken.count).to eq invtokcountbefore
        expect(responseobj.invitation_set.invitation_tokens.count).to eq invtoksininvsetbefore
        expect(responseobj.invitation_set.invitations.first.invited_state).to eq Invitation::NOT_SENT_STATE
        expect(responseobj.invitation_set.invitation_text).to be_nil
      end

      it 'should send the first text if the questionnaire is not a voormeting and it is the first one' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: mentor,
                                                  filling_out_for: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek, open_duration: 36.hours)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 24.hour.ago,
                                        measurement: measurement)
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        smstext = 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
          'Vul nu de eerste wekelijkse vragenlijst in.'
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

      it 'should send the second text if the questionnaire is not a voormeting and it is not the first one' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: mentor,
                                                  filling_out_for: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek, open_duration: 36.hours)
        FactoryBot.create(:response, :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 24.hour.ago,
                          completed_at: 10.hours.ago,
                          measurement: measurement)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 24.hour.ago,
                                        measurement: measurement)
        FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
        smstext = 'Hoi Jane, je wekelijkse vragenlijsten staan weer voor je klaar!'
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
  end

  describe 'max_attempts' do
    it 'should be two' do
      expect(subject.max_attempts).to eq 2
    end
  end

  describe 'reschedule_at' do
    it 'should be in one hour' do
      time_now = Time.zone.now
      expect(subject.reschedule_at(time_now, 1)).to be_within(1.minute)
        .of(TimeTools.increase_by_duration(time_now, 1.hour))
    end
  end
end
