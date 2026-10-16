# frozen_string_literal: true

require 'rails_helper'

describe DateGenerator do
  let(:question) { { id: :v1, type: :date, title: 'Welke dag is het vandaag?' } }

  it 'uses the Dutch placeholder for nl' do
    result = described_class.new.generate(question.merge(locale: 'nl'))
    expect(result).to include('Vul een datum in')
    expect(result).to include('data-locale="nl"')
  end

  it 'uses the English placeholder for en' do
    result = described_class.new.generate(question.merge(locale: 'en'))
    expect(result).to include('Fill out a date')
  end

  it 'uses the Finnish placeholder for fi' do
    result = described_class.new.generate(question.merge(locale: 'fi'))
    expect(result).to include('Valitse päivämäärä')
    expect(result).to include('data-locale="fi"')
  end

  it 'falls back to the English placeholder for other locales' do
    result = described_class.new.generate(question.merge(locale: 'de'))
    expect(result).to include('Fill out a date')
  end

  it 'uses the Dutch placeholder when no locale is given' do
    result = described_class.new.generate(question)
    expect(result).to include('Vul een datum in')
  end
end
