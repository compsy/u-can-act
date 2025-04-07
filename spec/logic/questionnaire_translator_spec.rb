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
  end
end
