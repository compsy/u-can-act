# frozen_string_literal: true

require 'rails_helper'

describe ResponseExporter do
  let!(:response) { FactoryGirl.create(:response, :completed) }
  context 'invalid questionnaire' do
    it 'should raise an error' do
      expect { described_class.export_lines('not-a-questionnaire') }.to raise_error(RuntimeError,
                                                                                    'Questionnaire not found')
    end
  end

  context 'with valid questionnaire' do
    it 'works with responses' do
      export = described_class.export_lines(response.measurement.questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 2
      expect(export.last.split(';').first).to eq "\"#{response.id}\""
      # bubblebabble format for second field (person_id)
      expect(export.last.split(';').second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';').size).to eq export.first.split(';').size
    end
    it 'works without responses' do
      questionnaire = FactoryGirl.create(:questionnaire)
      export = described_class.export_lines(questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 1
      expect(export.last.split(';').first).to eq '"response_id"'
      expect(export.last.split(';').second).to eq '"person_id"'
      expect(export.last.split(';').last).to eq '"updated_at"'
    end
  end
end
