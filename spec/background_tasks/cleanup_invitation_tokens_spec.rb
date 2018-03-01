# frozen_string_literal: true

require 'rails_helper'

describe CleanupInvitationTokens do
  describe 'run' do
    it 'should call the active scope' do
      expect(InvitationToken).to receive(:all).and_return []
      described_class.run
    end

    describe 'loops through all invitation tokens' do
      # This is also tested without mocking the expired? function in a feature test.
      it 'should destroy invitation tokens if they are expired' do
        FactoryBot.create_list(:invitation_token, 17)
        allow_any_instance_of(InvitationToken).to receive(:expired?).and_return(true)
        expect(InvitationToken.count).to eq 17
        described_class.run
        expect(InvitationToken.count).to be_zero
        expect(Response.count).to eq 17
      end

      it 'should not destroy invitation tokens if they are not expired' do
        FactoryBot.create_list(:invitation_token, 17)
        allow_any_instance_of(InvitationToken).to receive(:expired?).and_return(false)
        expect(InvitationToken.count).to eq 17
        described_class.run
        expect(InvitationToken.count).to eq 17
        expect(Response.count).to eq 17
      end
    end
  end
end
