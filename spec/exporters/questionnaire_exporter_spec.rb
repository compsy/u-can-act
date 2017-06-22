# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireExporter do
  let!(:questionnaire) { FactoryGirl.create(:questionnaire) }
  context 'invalid questionnaire' do
    it 'should raise an error' do
      expect { described_class.export_lines('not-a-questionnaire') }.to raise_error(RuntimeError,
                                                                                    'Questionnaire not found')
    end
  end

  context 'with questionnaire content' do
    it 'works with questionnaire content' do
      export = described_class.export_lines(questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 4
      expect(export.last.split(';', -1).first).to eq '"v3"'
      expect(export.last.split(';', -1).second).to eq '"3"'
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
  end
end
