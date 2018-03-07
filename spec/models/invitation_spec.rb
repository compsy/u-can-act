# frozen_string_literal: true

require 'rails_helper'

describe Invitation do
  it 'should have valid default properties' do
    invitation = FactoryBot.build(:invitation)
    expect(invitation.valid?).to be_truthy
  end
  it 'should have valid default properties for email type' do
    invitation = FactoryBoy.build(:invitation, :email)
    expect(invitation.valid?).to be_truthy
  end

  describe 'person' do
    it 'should have one' do
      invitation_set = FactoryBot.build(:invitation_set, person_id: nil)
      expect(invitation_set.valid?).to be_falsey
      expect(invitation_set.errors.messages).to have_key :person_id
      expect(invitation_set.errors.messages[:person_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Person' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect(invitation_set.person).to be_a(Person)
    end
  end

  describe 'type' do
    it 'cannot be set to nil' do
      invitation = FactoryBot.build(:invitation, type: nil)
      expect(invitation.valid?).to be_falsey
    end
    it 'cannot be set to any string' do
      invitation = FactoryBot.build(:invitation, type: 'someklass')
      expect(invitation.valid?).to be_falsey
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::NOT_SENT_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::SENDING_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::SENT_STATE
      expect(invitation.valid?).to be_truthy
    end
    it 'should not be nil' do
      invitation = FactoryBot.build(:invitation, invited_state: nil)
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      invitation = FactoryBot.build(:invitation, invited_state: '')
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      invitation = FactoryBot.build(:invitation, invited_state: 'somestring')
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation = FactoryBot.create(:invitation)
      expect(invitation.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'sending!' do
    # TODO: Fix me
  end

  describe 'sent!' do
    # TODO: fix me
  end

  describe 'send mails' do
    # TODO: FIX BELOW
    it 'should not raise if the mail sending fails' do
      questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
      response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      allow(SendSms).to receive(:run!).with(any_args).and_return true
      allow(InvitationMailer).to receive(:invitation_mail).and_raise(RuntimeError, 'Crashing')
      expect { described_class.run!(response: response) }.to_not raise_error
    end

    it 'should call the logger if anything fails' do
      questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
      response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      allow(SendSms).to receive(:run!).with(any_args).and_return true
      message = 'crashing'
      allow(InvitationMailer).to receive(:invitation_mail).and_raise(RuntimeError, message)
      expect(Rails.logger).to receive(:warn).with("[Attention] Mailgun failed again: #{message}").once
      expect(Rails.logger).to receive(:warn).with(any_args).once

      described_class.run!(response: response)
    end

    it 'should also send the invitation via email' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student,
                                                start_date: 1.week.ago.at_beginning_of_day)
      dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
      measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                              measurement: measurement)
      myid = response.protocol_subscription.person.external_identifier
      mytok = response.invitation_token.token_plain
      message = 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
              'Vul nu de eerste wekelijkse vragenlijst in.'

      allow(SendSms).to receive(:run!)
      invitation_url = "#{ENV['HOST_URL']}?q=#{myid}#{mytok}"
      expect(InvitationMailer).to receive(:invitation_mail).with(mentor.email,
                                                                 message,
                                                                 invitation_url).and_call_original
      described_class.run!(response: response)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq mentor.email
    end

    it 'should not try to send an email if the mentor does not have an email address' do
      mentor.update_attributes!(email: nil)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student,
                                                start_date: 1.week.ago.at_beginning_of_day)
      dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
      measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                   measurement: measurement)
      allow(SendSms).to receive(:run!)
      expect(InvitationMailer).to_not receive(:invitation_mail)
    end
  end
end
