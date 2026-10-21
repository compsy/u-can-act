# frozen_string_literal: true

require 'rails_helper'

describe 'fi translations of the questionnaire interface' do
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

  it 'has every questionnaires key that en has, except the nl/en language switch' do
    en_keys = leaf_keys(own_translations(:en)[:questionnaires]) - %w[language_switch]
    fi_keys = leaf_keys(own_translations(:fi)[:questionnaires])
    expect(en_keys - fi_keys).to be_empty
  end

  it 'translates the questionnaire texts into fi' do
    expect(I18n.t('questionnaires.save', locale: :fi)).to eq 'Tallenna'
    expect(I18n.t('questionnaires.placeholders.otherwise', locale: :fi)).to eq 'Muu, mikä:'
    expect(I18n.t('time.time', locale: :fi)).to eq 'Aika'
  end

  it 'has fi date and month names from rails-i18n' do
    date = Date.new(2026, 10, 19)
    expect(I18n.l(date, format: '%A %e %B', locale: :fi)).to eq 'maanantai 19 lokakuu'
    expect(I18n.t('time.am', locale: :fi)).to eq 'aamupäivä'
  end

  it 'keeps falling back to en for the other new locales' do
    expect(I18n.t('questionnaires.save', locale: :de)).to eq 'Save'
  end
end
