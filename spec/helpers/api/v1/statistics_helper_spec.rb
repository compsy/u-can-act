# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::StatisticsHelper do
  describe 'number_of_informed_consents_given' do
    it 'should return the number of filled out informed consents' do
      protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'my_protocol')
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      protocol3 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'noinformed')
      FactoryBot.create(:protocol_subscription, protocol: protocol, person: FactoryBot.create(:student),
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: FactoryBot.create(:student),
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: FactoryBot.create(:student),
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: FactoryBot.create(:mentor),
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol3, person: FactoryBot.create(:mentor))
      FactoryBot.create(:protocol_subscription, protocol: protocol3, person: FactoryBot.create(:student))
      FactoryBot.create(:protocol_subscription, protocol: protocol3, person: FactoryBot.create(:student))
      FactoryBot.create(:protocol_subscription, protocol: protocol3, person: FactoryBot.create(:student))
      FactoryBot.create(:protocol_subscription, protocol: protocol3, person: FactoryBot.create(:student))
      expect(helper.number_of_informed_consents_given(Person::MENTOR)).to eq(1)
      expect(helper.number_of_informed_consents_given(Person::STUDENT)).to eq(3)
    end

    it 'should not give an error if no protocol subscriptions were found' do
      expect(helper.number_of_informed_consents_given(Person::STUDENT)).to eq(0)
    end

    it 'should not count people twice' do
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      person = FactoryBot.create(:student)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: person,
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: person,
                                                informed_consent_given_at: Time.zone.now)
      expect(helper.number_of_informed_consents_given(Person::STUDENT)).to eq(1)
    end
  end
end
