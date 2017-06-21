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
      FactoryGirl.create :student
      FactoryGirl.create :person
      FactoryGirl.create :mentor
    end
    it 'works with people' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 4
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';').first).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';').size).to eq export.first.split(';').size
    end
  end
end
