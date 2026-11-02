# frozen_string_literal: true

require 'rails_helper'

describe 'translations of the questionnaire interface' do
  def leaf_keys(hash, prefix = nil)
    hash.flat_map do |key, value|
      path = [prefix, key].compact.join('.')
      value.is_a?(Hash) ? leaf_keys(value, path) : [path]
    end
  end

  def own_translations(locale)
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    I18n.backend.send(:translations)[locale]
  end

  %i[fi de es pt].each do |locale|
    it "has every questionnaires key that en has in #{locale}, except the nl/en language switch" do
      en_keys = leaf_keys(own_translations(:en)[:questionnaires]) - %w[language_switch]
      locale_keys = leaf_keys(own_translations(locale)[:questionnaires])
      expect(en_keys - locale_keys).to be_empty
    end
  end

  %i[fi de es pt].each do |locale|
    it "has every language page and klaar page key that en has in #{locale}" do
      en_keys = leaf_keys(own_translations(:en)[:pages].slice(:languages, :klaar))
      locale_keys = leaf_keys(own_translations(locale)[:pages].slice(:languages, :klaar))
      expect(en_keys - locale_keys).to be_empty
    end
  end

  it 'translates the questionnaire texts' do
    expected = {
      fi: ['Tallenna', 'Muu, mikä:', 'Aika'],
      de: ['Speichern', 'Sonstiges, und zwar:', 'Uhrzeit'],
      es: ['Guardar', 'Otro (especifique):', 'Hora'],
      pt: ['Guardar', 'Outro (especifique):', 'Hora']
    }
    expected.each do |locale, (save, otherwise, time)|
      expect(I18n.t('questionnaires.save', locale: locale)).to eq save
      expect(I18n.t('questionnaires.placeholders.otherwise', locale: locale)).to eq otherwise
      expect(I18n.t('time.time', locale: locale)).to eq time
    end
  end

  it 'has date and month names from rails-i18n' do
    date = Date.new(2026, 10, 19)
    expect(I18n.l(date, format: '%A %e %B', locale: :fi)).to eq 'maanantai 19 lokakuu'
    expect(I18n.t('time.am', locale: :fi)).to eq 'aamupäivä'
    expect(I18n.l(date, format: '%A %e %B', locale: :de)).to eq 'Montag 19 Oktober'
    expect(I18n.l(date, format: '%A %e %B', locale: :es)).to eq 'lunes 19 octubre'
    expect(I18n.l(date, format: '%A %e %B', locale: :pt)).to eq 'segunda-feira 19 outubro'
  end

  it 'keeps falling back to en for keys without a translation' do
    expect(I18n.t('questionnaires.language_switch', locale: :de)).to eq 'NL'
  end
end
