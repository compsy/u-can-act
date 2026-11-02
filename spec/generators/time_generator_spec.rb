# frozen_string_literal: true

require 'rails_helper'

describe TimeGenerator do
  let(:question) { { id: :v1, type: :time, title: 'Hoe lang?', raw: { id: :v1, type: :time, title: 'Hoe lang?' } } }

  it 'shows the default hours and minutes labels in the language of the participant' do
    { 'nl' => %w[Uren Minuten], 'en' => %w[Hours Minutes], 'fi' => %w[Tunnit Minuutit],
      'de' => %w[Stunden Minuten], 'es' => %w[Horas Minutos], 'pt' => %w[Horas Minutos] }.each do |locale, labels|
      result = described_class.new.generate(question.merge(locale: locale))
      labels.each { |label| expect(result).to include("<label>#{label}</label>") }
    end
  end

  it 'keeps storing the answers with the Dutch keys' do
    result = described_class.new.generate(question.merge(locale: 'de'))
    expect(result).to include('v1_uren')
    expect(result).to include('v1_minuten')
  end
end
