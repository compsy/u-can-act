# frozen_string_literal: true

require 'rails_helper'

describe PersonExporter do
  context 'without people' do
    it 'works without people' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with people' do
    before do
      FactoryBot.create :student
      FactoryBot.create :person
      FactoryBot.create :mentor
      # Create a person that should be filtered out
      FactoryBot.create(:student, mobile_phone: '0611055958')
    end
    it 'works with people' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 4
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';', -1).first).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
  end
end
