# frozen_string_literal: true

require 'rails_helper'

describe InvitationMailer do
  describe 'sets the default from' do
    it 'has a from address' do
      expect(ENV.fetch('FROM_EMAIL_ADDRESS', nil)).not_to be_blank
    end
  end

  describe 'invitation_mail' do
    let(:email_address) { 'email@email.com' }
    let(:invitation_url) { 'test.com' }
    let(:message) { 'welcome at vsv' }

    it 'sets the evaluation url in a instance variable' do
      allow(subject).to receive(:mail).and_return(true)
      expect(subject.instance_variable_get(:@invitation_url)).to be_blank
      expect(subject.instance_variable_get(:@message)).to be_blank
      subject.invitation_mail(email_address, message, invitation_url, 'myprotocol', 'nl', Time.zone.now)
      expect(subject.instance_variable_get(:@invitation_url)).not_to be_blank
      expect(subject.instance_variable_get(:@invitation_url)).to eq invitation_url

      expect(subject.instance_variable_get(:@message)).not_to be_blank
      expect(subject.instance_variable_get(:@message)).to eq message
    end

    it 'calls the mail function with the correct subject and to address' do
      allow(subject).to receive(:mail).with(subject: "Vragenlijst demo #{Time.zone.now.strftime('%d-%m-%Y')}",
                                            to: email_address)
      subject.invitation_mail(email_address, message, invitation_url, 'myprotocol', 'nl', Time.zone.now)
    end
  end

  describe 'registration_mail' do
    let(:email_address) { 'email@email.com' }
    let(:registration_url) { 'test.com' }
    let(:message) { 'welcome at vsv' }

    it 'sets the evaluation url in a instance variable' do
      allow(subject).to receive(:mail).and_return(true)
      expect(subject.instance_variable_get(:@registration_url)).to be_blank
      expect(subject.instance_variable_get(:@message)).to be_blank
      subject.registration_mail(email_address, message, registration_url)
      expect(subject.instance_variable_get(:@registration_url)).not_to be_blank
      expect(subject.instance_variable_get(:@registration_url)).to eq registration_url

      expect(subject.instance_variable_get(:@message)).not_to be_blank
      expect(subject.instance_variable_get(:@message)).to eq message
    end

    it 'calls the mail function with the correct subject and to address' do
      allow(subject).to receive(:mail).with(
        subject: Rails.application.config.settings.registration.subject_line, to: email_address
      )
      subject.registration_mail(email_address, message, registration_url)
    end
  end
end
