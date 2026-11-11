# frozen_string_literal: true

require 'rails_helper'

describe GenerateInvitationText do
  describe 'run' do
    describe 'protocol with invitation text' do
      it 'returns the text of a protocol if one is set' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        result = described_class.run!(response: response)
        expect(result).to be_a String
        expect(result).to eq protocol.invitation_text
      end

      it 'returns the text of a protocol subscription if one is set' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  invitation_text_nl: 'invitation-text-nl',
                                                  invitation_text_en: 'invitation-text-en')
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        result = described_class.run!(response: response)
        expect(result).to be_a String
        expect(result).to eq 'invitation-text-nl'
      end

      it 'writes dates in the language of the invitation text' do
        Timecop.freeze(Time.zone.local(2026, 10, 19, 12)) do
          protocol = FactoryBot.create(:protocol, :with_invitation_text)
          texts = { 'nl' => 'Vandaag is het {{datum_lang}}', 'en' => 'Today is {{datum_lang}}',
                    'fi' => 'Tänään on {{datum_lang}}' }
          { 'nl' => :nl, 'en' => :en, 'fi' => :fi, 'de' => :en }.each do |locale, text_locale|
            person = FactoryBot.create(:person, locale: locale)
            protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                      protocol: protocol,
                                                      person: person,
                                                      invitation_texts: texts)
            response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)
            date = I18n.l(Time.zone.today, format: :long, locale: text_locale)
            expect(described_class.run!(response: response)).to end_with(date)
          end
          expect(%i[nl en fi].map { |locale| I18n.l(Time.zone.today, format: :long, locale: locale) }.uniq.size).to eq 3
        end
      end

      it 'returns the localized text of a protocol if one is set' do
        person = FactoryBot.create(:person, locale: 'en')
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  person: person,
                                                  invitation_text_nl: 'invitation-text-nl',
                                                  invitation_text_en: 'invitation-text-en')
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        result = described_class.run!(response: response)
        expect(result).to be_a String
        expect(result).to eq 'invitation-text-en'
      end

      it 'returns the en text of a protocol subscription for other locales' do
        person = FactoryBot.create(:person, locale: 'fi')
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  person: person,
                                                  invitation_text_nl: 'invitation-text-nl',
                                                  invitation_text_en: 'invitation-text-en')
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        expect(described_class.run!(response: response)).to eq 'invitation-text-en'
      end

      it 'returns the text of a protocol subscription in the locale of the person' do
        person = FactoryBot.create(:person, locale: 'fi')
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  person: person,
                                                  invitation_texts: { 'nl' => 'invitation-text-nl',
                                                                      'en' => 'invitation-text-en',
                                                                      'fi' => 'invitation-text-fi' })
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        expect(described_class.run!(response: response)).to eq 'invitation-text-fi'
      end

      it 'returns the en text of a protocol subscription when the nl locale has no text' do
        person = FactoryBot.create(:person, locale: 'nl')
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  person: person,
                                                  invitation_texts: { 'en' => 'invitation-text-en' })
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        expect(described_class.run!(response: response)).to eq 'invitation-text-en'
      end

      it 'returns the nl text of a protocol subscription when there is no text for the locale nor en' do
        person = FactoryBot.create(:person, locale: 'fi')
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  protocol: protocol,
                                                  person: person,
                                                  invitation_text_nl: 'invitation-text-nl')
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        expect(described_class.run!(response: response)).to eq 'invitation-text-nl'
      end

      it 'returns the text of the protocol in Dutch when the protocol subscription has no text to fall back to' do
        Timecop.freeze(Time.zone.local(2026, 10, 19, 12)) do
          person = FactoryBot.create(:person, locale: 'fi')
          protocol = FactoryBot.create(:protocol, invitation_text: 'Vandaag is het {{datum_lang}}')
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    protocol: protocol,
                                                    person: person,
                                                    invitation_texts: { 'de' => 'invitation-text-de' })
          response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

          date = I18n.l(Time.zone.today, format: :long, locale: :nl)
          expect(described_class.run!(response: response)).to eq "Vandaag is het #{date}"
        end
      end

      it 'evaluates the values in the the text of a protocol' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        subs_hash = {}
        expected = 'expected outcome'
        expect(VariableSubstitutor).to receive(:substitute_variables)
          .with(response).and_return(subs_hash)
        expect(VariableEvaluator).to receive(:evaluate_obj)
          .with(protocol.invitation_text, subs_hash)
          .and_return(expected)

        result = described_class.run!(response: response)
        expect(result).to eq expected
      end
    end

    describe 'protocol without invitation text' do
      describe 'student' do
        let(:protocol) { FactoryBot.create(:protocol) }
        let(:student) { FactoryBot.create(:student) }
        let(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            end_date: 10.days.from_now,
                            protocol: protocol, person: student)
        end
        let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

        it 'calls the student invitation texts generator' do
          expected = 'test'
          expect(StudentInvitationTexts).to receive(:message)
            .with(response)
            .and_return(expected)
          result = described_class.run!(response: response)
          expect(result).to eq(expected)
        end
      end

      describe 'mentor' do
        let(:questionnaire) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
        let(:protocol) { FactoryBot.create(:protocol) }
        let(:measurement1) { FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol) }
        let(:measurement2) { FactoryBot.create(:measurement, protocol: protocol) }
        let(:mentor) { FactoryBot.create(:mentor) }
        let(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            end_date: 10.days.from_now,
                            protocol: protocol, person: mentor)
        end
        let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

        it 'calls the mentor invitation texts generator' do
          expected = 'test'
          expect(MentorInvitationTexts).to receive(:message)
            .with(response)
            .and_return(expected)
          result = described_class.run!(response: response)
          expect(result).to eq(expected)
        end
      end
    end
  end
end
