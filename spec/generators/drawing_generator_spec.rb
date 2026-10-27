# frozen_string_literal: true

require 'rails_helper'

describe DrawingGenerator do
  let(:question) { { id: :v1, type: :drawing, title: 'Teken iets', width: 100, height: 100, image: 'bodymap.png' } }

  it 'uses the button texts of the locale' do
    result = described_class.new.generate(question.merge(locale: 'fi'))
    expect(result).to include('Tyhjennä')
    expect(result).to include('data-lock-text="Valmis (seuraava kysymys)"')
    expect(result).to include('data-unlock-text="Muokkaa"')
  end

  it 'keeps the Dutch button texts for nl' do
    result = described_class.new.generate(question.merge(locale: 'nl'))
    expect(result).to include('Opnieuw')
    expect(result).to include('data-lock-text="Klaar (volgende vraag)"')
    expect(result).to include('data-unlock-text="Aanpassen"')
  end
end
