# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireTranslator do
  describe 'translate_content' do
    it 'takes the given translation for something' do
      content = { nl: 'Hier is wat tekst', en: 'Here is some text' }
      mockresult = 'Hier is wat tekst'
      result = described_class.translate_content(content, 'nl')
      expect(result).to eq mockresult
    end

    it 'works when the translation keys are strings' do
      content = { 'nl' => 'Hier is wat tekst', 'en' => 'Here is some text' }
      mockresult = 'Here is some text'
      result = described_class.translate_content(content, 'en')
      expect(result).to eq mockresult
    end

    it 'does nothing if no translation exists' do
      content = { nl: 'Hier is wat tekst', en: 'Here is some text' }
      mockresult = { nl: 'Hier is wat tekst', en: 'Here is some text' }
      result = described_class.translate_content(content, 'i18n')
      expect(result).to eq mockresult
    end

    it 'works within nested structures' do
      content = { id: :v2,
                  type: :checkbox,
                  title: { nl: 'Wat heeft u vandaag gegeten?', en: 'What you eat now' },
                  options: [
                    { title: { nl: 'brood', en: 'bread' },
                      tooltip: { nl: 'Bijvoorbeeld met hagelslag', en: 'For example with hagel slag' } },
                    { title: { nl: 'kaas en ham', en: 'Cheese and ham' } },
                    { title: 'pizza' }
                  ] }
      mockresult = { id: :v2,
                     type: :checkbox,
                     title: 'Wat heeft u vandaag gegeten?',
                     options: [
                       { title: 'brood', tooltip: 'Bijvoorbeeld met hagelslag' },
                       { title: 'kaas en ham' },
                       { title: 'pizza' }
                     ] }
      result = described_class.translate_content(content, 'nl')
      expect(result).to eq mockresult
    end

    describe 'fallbacks' do
      let(:content) { { title: { nl: 'Hoe gaat het?', en: 'How are you?', fi: 'Mitä kuuluu?' } } }

      it 'uses the requested language when it exists' do
        expect(described_class.translate_content(content, 'fi')).to eq(title: 'Mitä kuuluu?')
      end

      it 'accepts the locale as a symbol' do
        expect(described_class.translate_content(content, :fi)).to eq(title: 'Mitä kuuluu?')
      end

      it 'falls back to en when the requested language does not exist' do
        expect(described_class.translate_content(content, 'de')).to eq(title: 'How are you?')
      end

      it 'falls back to nl when neither the requested language nor en exist' do
        content = { title: { nl: 'Hoe gaat het?', fi: 'Mitä kuuluu?' } }
        expect(described_class.translate_content(content, 'de')).to eq(title: 'Hoe gaat het?')
      end

      it 'prefers en over nl as fallback' do
        content = { title: { 'nl' => 'Hoe gaat het?', 'en' => 'How are you?' } }
        expect(described_class.translate_content(content, 'pt')).to eq(title: 'How are you?')
      end

      it 'keeps nl and en behaviour unchanged' do
        expect(described_class.translate_content(content, 'nl')).to eq(title: 'Hoe gaat het?')
        expect(described_class.translate_content(content, 'en')).to eq(title: 'How are you?')
      end

      it 'falls back per text' do
        content = { questions: [{ title: { nl: 'Hoe gaat het?', en: 'How are you?', fi: 'Mitä kuuluu?' } },
                                { title: { nl: 'Hoe oud ben je?', en: 'How old are you?' } }] }
        result = described_class.translate_content(content, 'fi')
        expect(result).to eq(questions: [{ title: 'Mitä kuuluu?' }, { title: 'How old are you?' }])
      end

      it 'does not fall back for the i18n pseudo locale' do
        content = { title: { nl: 'brood', en: 'bread' }, other: { i18n: 'bread_key', nl: 'kaas', en: 'cheese' } }
        result = described_class.translate_content(content, 'i18n')
        expect(result).to eq(title: { nl: 'brood', en: 'bread' }, other: 'bread_key')
      end

      it 'translates the i18n leftovers to nl in a second pass, so stored values stay Dutch' do
        content = { options: [{ title: { nl: 'brood', en: 'bread', fi: 'leipä' } }] }
        raw = described_class.translate_content(content, 'i18n')
        raw = described_class.translate_content(raw, 'nl')
        expect(raw).to eq(options: [{ title: 'brood' }])
      end
    end

    it 'does not change its input' do
      content = { questions: [{ id: :v1, title: { nl: 'Hoe gaat het?', en: 'How are you?' } }] }
      original = content.deep_dup
      described_class.translate_content(content, 'fi')
      expect(content).to eq original
    end
  end

  describe 'languages' do
    it 'returns all languages used in the content' do
      content = { questions: [{ title: { nl: 'a', en: 'b' } }, { title: { nl: 'c', fi: 'd' }, labels: %w[x y] }] }
      expect(described_class.languages(content)).to match_array %w[nl en fi]
    end

    it 'ignores the i18n pseudo locale' do
      expect(described_class.languages({ title: { i18n: 'a', nl: 'b' } })).to eq %w[nl]
    end

    it 'returns an empty array for content without language keys' do
      expect(described_class.languages({ title: 'Hoe gaat het?' })).to eq []
    end
  end

  describe 'available_in?' do
    it 'is true when every text has the locale or en' do
      content = [{ nl: 'a', fi: 'b' }, { nl: 'c', en: 'd' }]
      expect(described_class.available_in?(content, 'fi')).to be true
    end

    it 'is false when a text has neither the locale nor en' do
      content = [{ nl: 'a', fi: 'b' }, { nl: 'c', de: 'd' }]
      expect(described_class.available_in?(content, 'fi')).to be false
    end
  end

  describe 'valid_translations?' do
    it 'requires nl' do
      expect(described_class.valid_translations?({ title: { en: 'a', fi: 'b' } })).to be false
    end

    it 'does not require other languages' do
      expect(described_class.valid_translations?({ title: { nl: 'a' } })).to be true
      expect(described_class.valid_translations?({ title: { nl: 'a', fi: 'b' } })).to be true
    end

    it 'checks nested texts' do
      content = { questions: [{ title: { nl: 'a', en: 'b' }, options: [{ title: { fi: 'c' } }] }] }
      expect(described_class.valid_translations?(content)).to be false
    end
  end

  describe 'multi_language?' do
    it 'returns false for empty content' do
      content = nil
      expect(described_class.multi_language?(content)).to eq false
    end
    it 'returns false for non-multi-language content' do
      content = { id: :v1, type: :range, title: 'How are you today?', labels: %w[slecht goed] }
      expect(described_class.multi_language?(content)).to eq false
    end
    it 'returns true for multi-language content' do
      content = { id: :v1, type: :range, title: {
        en: 'How are you today?', nl: 'Hoe voelt {{deze_student}} zich vandaag?'
      }, labels: %w[slecht goed] }
      expect(described_class.multi_language?(content)).to eq true
    end
    it 'returns true for content in other languages than nl and en' do
      content = { id: :v1, type: :range, title: { nl: 'Hoe gaat het?', fi: 'Mitä kuuluu?' } }
      expect(described_class.multi_language?(content)).to eq true
    end
    it 'returns false for content in only one language' do
      content = { id: :v1, type: :range, title: { nl: 'Hoe gaat het?' } }
      expect(described_class.multi_language?(content)).to eq false
    end
  end
end
