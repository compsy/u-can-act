# frozen_string_literal: true

require 'rails_helper'

describe PersonExporter do
  it_should_behave_like 'an object_exporter object'

  context 'without people' do
    it 'works without people' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with people' do
    let!(:student) { FactoryBot.create :student }
    let!(:person) { FactoryBot.create :person }
    let!(:mentor) { FactoryBot.create :mentor }

    # Create a person that should be filtered out
    let!(:student2) { FactoryBot.create(:student, :with_test_phone_number) }

    describe 'works with people' do
      let(:export) { described_class.export_lines.to_a.join.split("\n") }

      it 'creates the correct bubblebable format' do
        expect(export.size).to eq 4

        # bubblebabble format for first field (person_id)
        expect(export.last.split(';', -1).first).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
        expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
      end
    end
  end
end
