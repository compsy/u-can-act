# frozen_string_literal: true

require 'rails_helper'

describe SmsInvitation do
  describe 'checks attributes' do
    it 'calls appsignal whenever a phone number is missing' do
      invitation = FactoryBot.create(:sms_invitation)
      expect(invitation).to be_valid
      invitation.person.update!(mobile_phone: nil)
      expect(Appsignal).to receive(:set_error)
      expect(SendSms).to_not receive(:run!)
      invitation.send_invite('abc')
    end
  end
end
