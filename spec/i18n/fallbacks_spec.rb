# frozen_string_literal: true

require 'rails_helper'

describe 'i18n fallbacks' do
  it 'does not let nl fall back to another locale' do
    expect(I18n.fallbacks[:nl]).to eq %i[nl]
  end

  it 'lets en fall back to nl' do
    expect(I18n.fallbacks[:en]).to eq %i[en nl]
  end

  it 'lets the other locales fall back to en first' do
    %i[fi de es pt].each do |locale|
      expect(I18n.fallbacks[locale]).to eq [locale, :en, :nl]
    end
  end
end
