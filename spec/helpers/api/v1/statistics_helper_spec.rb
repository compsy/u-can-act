# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::StatisticsHelper do
  describe 'number_of_informed_consents_given' do
    it 'returns the number of filled out informed consents' do
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

    it 'does not give an error if no protocol subscriptions were found' do
      expect(helper.number_of_informed_consents_given(Person::STUDENT)).to eq(0)
    end

    it 'does not count people twice' do
      protocol2 = FactoryBot.create(:protocol, :with_informed_consent_questionnaire, name: 'hihaho')
      person = FactoryBot.create(:student)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: person,
                                                informed_consent_given_at: Time.zone.now)
      FactoryBot.create(:protocol_subscription, protocol: protocol2, person: person,
                                                informed_consent_given_at: Time.zone.now)
      expect(helper.number_of_informed_consents_given(Person::STUDENT)).to eq(1)
    end
  end

  describe 'number_of_completed_questionnaires' do
    it 'returns the correct number of completed questionnaires' do
      student = FactoryBot.create(:student)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: student)
      FactoryBot.create_list(:response, 7, :completed, protocol_subscription: protocol_subscription)
      FactoryBot.create_list(:response, 4, protocol_subscription: protocol_subscription)
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor)
      FactoryBot.create_list(:response, 9, :completed, protocol_subscription: protocol_subscription)
      FactoryBot.create_list(:response, 3, protocol_subscription: protocol_subscription)
      solo = FactoryBot.create(:solo)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: solo)
      FactoryBot.create_list(:response, 12, :completed, protocol_subscription: protocol_subscription)
      FactoryBot.create_list(:response, 2, protocol_subscription: protocol_subscription)
      expect(helper.number_of_completed_questionnaires([Person::STUDENT, Person::MENTOR])).to eq 16
    end
    it 'works when there are no filled out questionnaires' do
      expect(helper.number_of_completed_questionnaires([Person::STUDENT, Person::MENTOR])).to be_zero
    end
    it 'works for an empty array of groups' do
      expect(helper.number_of_completed_questionnaires([])).to be_zero
    end
  end
end
