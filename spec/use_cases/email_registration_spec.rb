# frozen_string_literal: true

require 'rails_helper'

describe EmailRegistration do
  let(:email) { 'hoi@doei.com' }
  let!(:person) { FactoryBot.create(:person, email: email) }

  before do
    @old_values = ENV.to_h.slice('REGISTRATION_URL', 'SHARED_SECRET')
    ENV['REGISTRATION_URL'] = 'http://registration-url.nl'
    ENV['SHARED_SECRET'] = 'test shared secret'
  end

  after do
    %w[REGISTRATION_URL SHARED_SECRET].each { |key| ENV[key] = @old_values[key] }
  end

  it 'sends an email' do
    message = Rails.application.config.settings.registration.text
    expect(InvitationMailer).to receive(:registration_mail).with(person.email,
                                                                 message,
                                                                 %r{http://registration-url.nl}).and_call_original

    described_class.run!(person: person)
    expect(ActionMailer::Base.deliveries.last.to.first).to eq person.email
  end

  %w[REGISTRATION_URL SHARED_SECRET].each do |key|
    it "raises and sends no email when #{key} is blank" do
      ENV[key] = ''
      expect(InvitationMailer).not_to receive(:registration_mail)
      expect { described_class.run!(person: person) }.to raise_error(KeyError, /#{key}/)
    end

    it "raises and sends no email when #{key} is not set" do
      ENV.delete(key)
      expect(InvitationMailer).not_to receive(:registration_mail)
      expect { described_class.run!(person: person) }.to raise_error(KeyError, /#{key}/)
    end
  end
end
