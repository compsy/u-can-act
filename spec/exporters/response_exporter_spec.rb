# frozen_string_literal: true

require 'rails_helper'

describe ResponseExporter do
  let!(:responseobj) do
    response_content = FactoryBot.create(:response_content,
                                         content: { 'v1' => 'slecht', 'v23_2a13_brood' => 'true', 'v3' => '23.0' })
    FactoryBot.create(:response, :completed, content: response_content.id.to_s)
  end

  context 'invalid questionnaire' do
    it 'should raise an error' do
      expect { described_class.export_lines('not-a-questionnaire') }.to raise_error(RuntimeError,
                                                                                    'Questionnaire not found')
    end
  end

  context 'with valid questionnaire' do
    it 'works with responses' do
      # create a response that should be filtered out
      person = FactoryBot.create(:student, mobile_phone: '0611055958')
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: responseobj.measurement)
      export = described_class.export_lines(responseobj.measurement.questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 2
      expect(export.first).to match('"v1";"v3";"v23_2a13_brood"') # Test the sorting of keys
      expect(export.last.split(';', -1).first).to eq "\"#{responseobj.id}\""
      # bubblebabble format for second field (person_id)
      expect(export.last.split(';', -1).second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
    it 'works without responses' do
      questionnaire_content = [{
        section_start: 'Algemeen',
        id: :v1,
        type: :radio,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }, {
        id: :v23_2a13,
        type: :checkbox,
        title: 'Wat heeft u vandaag gegeten?',
        options: ['brood', 'kaas en ham', 'pizza']
      }, {
        id: :v3,
        type: :range,
        title: 'Hoe gaat het met u?',
        labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
        section_end: true
      }]
      questionnaire = FactoryBot.create(:questionnaire, content: questionnaire_content)
      export = described_class.export_lines(questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 1
      expect(export.last.split(';', -1).first).to eq '"response_id"'
      expect(export.last.split(';', -1).second).to eq '"filled_out_by_id"'
      expect(export.last.split(';', -1).last).to eq '"updated_at"'
    end
  end
end
