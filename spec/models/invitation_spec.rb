# frozen_string_literal: true

require 'rails_helper'

describe Invitation do
  it 'should have valid default properties' do
    invitation = FactoryBot.create(:sms_invitation)
    expect(invitation.valid?).to be_truthy
  end
  it 'should have valid default properties for email type' do
    invitation = FactoryBot.create(:email_invitation)
    expect(invitation.valid?).to be_truthy
  end

  describe 'invitation_set' do
    it 'should have one' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invitation_set_id = nil
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invitation_set_id
      expect(invitation.errors.messages[:invitation_set_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve an InvitationSet' do
      invitation = FactoryBot.create(:sms_invitation)
      expect(invitation.invitation_set).to be_an(InvitationSet)
    end
  end

  describe 'type' do
    it 'cannot be set to nil' do
      invitation = FactoryBot.create(:invitation, type: 'SmsInvitation')
      invitation.type = nil
      expect(invitation.valid?).to be_falsey
    end
    it 'does not throw errors with sms' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect do
        Invitation.create!(invitation_set: invitation_set, type: 'SmsInvitation')
      end.not_to raise_error
      expect do
        SmsInvitation.create!(invitation_set: invitation_set)
      end.not_to raise_error
    end
    it 'does not throw errors with email' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect do
        Invitation.create!(invitation_set: invitation_set, type: 'EmailInvitation')
      end.not_to raise_error
      expect do
        EmailInvitation.create!(invitation_set: invitation_set)
      end.not_to raise_error
    end
    it 'does throw errors with other types' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect do
        Invitation.create!(invitation_set: invitation_set, type: 'SomeKlass')
      end.to raise_error(ActiveRecord::SubclassNotFound)
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = Invitation::NOT_SENT_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = Invitation::SENDING_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = Invitation::SENT_STATE
      expect(invitation.valid?).to be_truthy
    end
    it 'should not be nil' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = nil
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = ''
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.invited_state = 'somestring'
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation = FactoryBot.create(:sms_invitation)
      expect(invitation.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'sending!' do
    it 'should update the invited_state to sending if it is not_sent' do
      invitation = FactoryBot.create(:sms_invitation)
      invitation.sending!
      expect(invitation.invited_state).to eq Invitation::SENDING_STATE
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::SENDING_STATE
    end
    it 'should update the invited_state to sending_reminder if it is sending' do
      invitation = FactoryBot.create(:sms_invitation, invited_state: Invitation::SENDING_STATE)
      invitation.sending!
      expect(invitation.invited_state).to eq Invitation::SENDING_REMINDER_STATE
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::SENDING_REMINDER_STATE
    end
    it 'should update the invited_state to sending_reminder if it is sent' do
      invitation = FactoryBot.create(:sms_invitation, invited_state: Invitation::SENT_STATE)
      invitation.sending!
      expect(invitation.invited_state).to eq Invitation::SENDING_REMINDER_STATE
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::SENDING_REMINDER_STATE
    end
  end

  describe 'sent!' do
    it 'should update the invited_state to sent if it is sending' do
      invitation = FactoryBot.create(:sms_invitation, invited_state: Invitation::SENDING_STATE)
      invitation.sent!
      expect(invitation.invited_state).to eq Invitation::SENT_STATE
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::SENT_STATE
    end
    it 'should update the invited_state to reminder_sent if it is sending_reminder' do
      invitation = FactoryBot.create(:sms_invitation, invited_state: Invitation::SENDING_REMINDER_STATE)
      invitation.sent!
      expect(invitation.invited_state).to eq Invitation::REMINDER_SENT_STATE
      invitation.reload
      expect(invitation.invited_state).to eq Invitation::REMINDER_SENT_STATE
    end
  end

  describe 'send_invite' do
    let(:mentor) { FactoryBot.create(:mentor) }
    let(:student) { FactoryBot.create(:student) }

    it 'should send both sms and email invites' do
      invitation_set = FactoryBot.create(:invitation_set, person: mentor)
      smsinvitation = FactoryBot.create(:sms_invitation, invitation_set: invitation_set)
      emailinvitation = FactoryBot.create(:email_invitation, invitation_set: invitation_set)
      expect(SendSms).to receive(:run!)
      # If mailing fails it raises an error, causing that job to be repeated (once)
      mailer = double('mailer')
      expect(mailer).to receive(:deliver_now)
      expect(InvitationMailer).to receive(:invitation_mail).and_return(mailer)
      mytok = 'asdf'
      expect do
        smsinvitation.send_invite(mytok)
        emailinvitation.send_invite(mytok)
      end.to_not raise_error
    end

    it 'should also send the invitation via email' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student,
                                                start_date: 1.week.ago.at_beginning_of_day)
      dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
      measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
      responseobj = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                           measurement: measurement)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      myid = responseobj.protocol_subscription.person.external_identifier
      mytok = invitation_token.token_plain
      message = 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
              'Vul nu de eerste wekelijkse vragenlijst in.'
      responseobj.invitation_set.update_attributes!(invitation_text: message)
      invitation_url = "#{ENV['HOST_URL']}/?q=#{myid}#{mytok}"
      allow(SendSms).to receive(:run!).with(number: mentor.mobile_phone,
                                            text: "#{message} #{invitation_url}",
                                            reference: "vsv-#{responseobj.invitation_set.id}")
      expect(InvitationMailer).to receive(:invitation_mail).with(mentor.email,
                                                                 message,
                                                                 invitation_url).and_call_original
      smsinvitation = FactoryBot.create(:sms_invitation, invitation_set: responseobj.invitation_set)
      emailinvitation = FactoryBot.create(:email_invitation, invitation_set: responseobj.invitation_set)
      smsinvitation.send_invite(mytok)
      emailinvitation.send_invite(mytok)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq mentor.email
    end

    it 'should not try to send an email if the mentor does not have an email address' do
      mentor.update_attributes!(email: nil)
      invitation_set = FactoryBot.create(:invitation_set, person: mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student,
                                                start_date: 1.week.ago.at_beginning_of_day)
      dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
      measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
      FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                             measurement: measurement, invitation_set: invitation_set)
      expect(SendSms).to receive(:run!)
      expect(InvitationMailer).to_not receive(:invitation_mail)
      smsinvitation = FactoryBot.create(:sms_invitation, invitation_set: invitation_set)
      emailinvitation = FactoryBot.create(:email_invitation, invitation_set: invitation_set)
      mytok = 'asdf'
      smsinvitation.send_invite(mytok)
      emailinvitation.send_invite(mytok)
    end
  end
end
