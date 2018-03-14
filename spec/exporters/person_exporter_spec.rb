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
    let!(:student2) { FactoryBot.create(:student, mobile_phone: '0611055958') }

    describe 'works with people' do
      let(:export) { described_class.export_lines.to_a.join.split("\n") }

      it 'creates the correct bubblebable format' do
        expect(export.size).to eq 4

        # bubblebabble format for first field (person_id)
        expect(export.last.split(';', -1).first).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
        expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
      end

      it 'introduces the correct headers' do
        headers = export.first.split("\;").map { |x| x.delete('"') }
        hash = described_class.send(:person_hash, person)

        # +3 for first_name, last_name, mobile_phone
        expect(headers.length).to eq(hash.length + 3)
        hash.each_key { |key| expect(headers).to include key }
      end
    end
  end
end
