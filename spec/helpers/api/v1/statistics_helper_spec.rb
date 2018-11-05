# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::StatisticsHelper do
  describe 'number_of_informed_consents_given' do
    it 'should return the number of filled out informed consents' do
      protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'my_protocol')
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      protocol3 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'noinformed')
      FactoryBot.create_list(:protocol_subscription, 1, protocol: protocol, informed_consent_given_at: Time.zone.now)
      FactoryBot.create_list(:protocol_subscription, 2, protocol: protocol2, informed_consent_given_at: Time.zone.now)
      FactoryBot.create_list(:protocol_subscription, 4, protocol: protocol3)
      expect(helper.number_of_informed_consents_given(%w[my_protocol hihaho noinformed])).to eq(3)
    end

    it 'should work for an empty list of protocol names' do
      expect(helper.number_of_informed_consents_given([])).to eq(0)
    end

    it 'should got give an error if no protocols were found' do
      expect(helper.number_of_informed_consents_given(%w[my_protocol hihaho])).to eq(0)
    end

    it 'should not give an error when some protocols were not found' do
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      FactoryBot.create_list(:protocol_subscription, 2, protocol: protocol2, informed_consent_given_at: Time.zone.now)
      expect(helper.number_of_informed_consents_given(%w[my_protocol hihaho])).to eq(2)
    end

    it 'should not count double protocol names' do
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      FactoryBot.create_list(:protocol_subscription, 2, protocol: protocol2, informed_consent_given_at: Time.zone.now)
      expect(helper.number_of_informed_consents_given(%w[hihaho hihaho])).to eq(2)
    end
  end
end
