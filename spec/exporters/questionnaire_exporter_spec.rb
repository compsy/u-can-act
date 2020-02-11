# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireExporter do
  let!(:questionnaire) { FactoryBot.create(:questionnaire, :with_scores) }

  context 'invalid questionnaire' do
    it 'raises an error' do
      expect { described_class.export_lines('not-a-questionnaire') }.to raise_error(RuntimeError,
                                                                                    'Questionnaire not found')
    end
  end

  context 'with questionnaire content' do
    it 'works with questionnaire content' do
      export = described_class.export_lines(questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 1 + # Header
                                3 + # Normal questions
                                5 + # Expandable questions
                                1   # Scores

      (1..3).each do |line_nr|
        expect(export[line_nr].split(';', -1).first).to eq "\"v#{line_nr}\""
        expect(export[line_nr].split(';', -1).second).to eq "\"#{line_nr}\""
        expect(export[line_nr].split(';', -1).size).to eq export.first.split(';', -1).size
      end

      (4..8).each_with_index do |line_nr, idx|
        expect(export[line_nr].split(';', -1).first).to eq "\"v4_#{idx + 1}\""
        expect(export[line_nr].split(';', -1).second).to eq "\"#{line_nr}\""
        expect(export[line_nr].split(';', -1).size).to eq export.first.split(';', -1).size
      end
    end
  end
end
