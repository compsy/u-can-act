# frozen_string_literal: true

require 'rails_helper'

describe TextareaGenerator do
  let(:question) { { id: :v1, type: :textarea, title: 'Wat vond je ervan?' } }

  it_behaves_like 'a generator'

  it 'uses the translated placeholder for nl' do
    expect(described_class.new.generate(question.merge(locale: 'nl'))).to include('Vul iets in')
  end

  it 'uses the translated placeholder for en' do
    expect(described_class.new.generate(question.merge(locale: 'en'))).to include('Enter something')
  end

  it 'uses the translated placeholder for fi' do
    expect(described_class.new.generate(question.merge(locale: 'fi'))).to include('Kirjoita vastaus')
  end
end
