# frozen_string_literal: true

require 'rails_helper'

describe EmailRegistration do
  let(:email) { 'hoi@doei.com' }
  let!(:person) { FactoryBot.create(:person, email: email) }

  before do
    @old_value = ENV.fetch('REGISTRATION_URL', nil)
    ENV['REGISTRATION_URL'] = 'http://registration-url.nl'
  end

  after do
    ENV['REGISTRATION_URL'] = @old_value
  end

  it 'sends an email' do
    message = Rails.application.config.settings.registration.text
    expect(InvitationMailer).to receive(:registration_mail).with(person.email,
                                                                 message,
                                                                 %r{http://registration-url.nl}).and_call_original

    described_class.run!(person: person)
    expect(ActionMailer::Base.deliveries.last.to.first).to eq person.email
  end
end
