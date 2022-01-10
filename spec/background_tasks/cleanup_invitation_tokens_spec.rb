# frozen_string_literal: true

require 'rails_helper'

describe CleanupInvitationTokens do
  describe 'run' do
    it 'calls the active scope' do
      expect(InvitationToken).to receive(:all).and_return []
      described_class.run
    end

    describe 'loops through all invitation tokens' do
      # This is also tested without mocking the expired? function in a feature test.
      it 'destroys invitation tokens if they are expired' do
        FactoryBot.create_list(:invitation_token, 17, created_at: (8.days + (6 * 4).weeks).ago)
        expect(InvitationToken.count).to eq 17
        described_class.run
        expect(InvitationToken.count).to be_zero
      end

      it 'does not destroy invitation tokens if they are not expired' do
        FactoryBot.create_list(:invitation_token, 17, created_at: (6.days + (6 * 4).weeks).ago)
        expect(InvitationToken.count).to eq 17
        described_class.run
        expect(InvitationToken.count).to eq 17
      end
    end

    it 'sets the expiry to the response expire time if it is more than 7 days from now' do
      measurement = FactoryBot.create(:measurement, open_duration: 10.days)
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:response, open_from: 1.hour.ago,
                                   invitation_set: invitation_set,
                                   measurement: measurement)
      FactoryBot.create(:invitation_token, invitation_set: invitation_set)
      described_class.run
      expect(InvitationToken.count).to eq 1
      expect(InvitationToken.first.expires_at).to(be_within(1.minute)
        .of(TimeTools.increase_by_duration(Time.zone.now, 10.days - 1.hour)))
    end
    it 'sets the expiry to 7 days from now if the response expire time is less than that' do
      measurement = FactoryBot.create(:measurement, open_duration: 6.days)
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:response, open_from: 1.hour.ago,
                                   invitation_set: invitation_set,
                                   measurement: measurement)
      FactoryBot.create(:invitation_token, invitation_set: invitation_set)
      described_class.run
      expect(InvitationToken.count).to eq 1
      expect(InvitationToken.first.expires_at).to(be_within(1.minute)
        .of(TimeTools.increase_by_duration(Time.zone.now, 7.days)))
    end
  end
end
