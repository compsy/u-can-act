# frozen_string_literal: true

require 'rails_helper'

describe DateAndTimeGenerator do
  let(:question) do
    { id: :v1, type: :date_and_time, title: 'Wanneer?', hours_id: :v1_hours, minutes_id: :v1_minutes }
  end

  it 'uses the Dutch placeholder for nl' do
    expect(described_class.new.generate(question.merge(locale: 'nl'))).to include('Vul een datum en tijd in')
  end

  it 'uses the English placeholder for en' do
    expect(described_class.new.generate(question.merge(locale: 'en'))).to include('Fill out a date and time')
  end

  it 'uses the Finnish placeholder for fi' do
    expect(described_class.new.generate(question.merge(locale: 'fi'))).to include('Valitse päivämäärä ja aika')
  end

  it 'falls back to the English placeholder for other locales' do
    expect(described_class.new.generate(question.merge(locale: 'de'))).to include('Fill out a date and time')
  end
end
