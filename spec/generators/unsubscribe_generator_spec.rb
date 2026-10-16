# frozen_string_literal: true

require 'rails_helper'

describe UnsubscribeGenerator do
  let(:question) { { id: :v1, type: :unsubscribe, title: 'Klaar met dit onderzoek?', unsubscribe_url: '/stop' } }

  it 'uses the default button text of the locale' do
    expect(described_class.new.generate(question.merge(locale: 'nl'))).to include('Uitschrijven')
    expect(described_class.new.generate(question.merge(locale: 'en'))).to include('Unsubscribe')
    expect(described_class.new.generate(question.merge(locale: 'fi'))).to include('Lopeta osallistuminen')
  end

  it 'uses the button text of the question when given' do
    expect(described_class.new.generate(question.merge(locale: 'fi', button_text: 'Stop'))).to include('Stop')
  end
end
