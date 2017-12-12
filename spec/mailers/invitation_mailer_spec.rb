# frozen_string_literal: true

require 'rails_helper'

describe InvitationMailer do
  describe 'sets the default from' do
    it 'should have a from address' do
      expect(ENV['FROM_EMAIL_ADDRESS']).to_not be_blank
    end
  end

  describe 'invitation_mail' do
    let(:email_address) { 'email@email.com' }
    let(:invitation_url) { 'test.com' }
    let(:message) { 'welcome at vsv' }
    it 'should set the evaluation url in a instance variable' do
      allow(subject).to receive(:mail).and_return(true)
      expect(subject.instance_variable_get(:@invitation_url)).to be_blank
      expect(subject.instance_variable_get(:@message)).to be_blank
      subject.invitation_mail(email_address, message, invitation_url)
      expect(subject.instance_variable_get(:@invitation_url)).to_not be_blank
      expect(subject.instance_variable_get(:@invitation_url)).to eq invitation_url

      expect(subject.instance_variable_get(:@message)).to_not be_blank
      expect(subject.instance_variable_get(:@message)).to eq message
    end

    it 'should call the mail function with the correct subject and to address' do
      allow(subject).to receive(:mail).with(subject: InvitationMailer::DEFAULT_INVITATION_SUBJECT, to: email_address)
      subject.invitation_mail(email_address, message, invitation_url)
    end
  end
end
