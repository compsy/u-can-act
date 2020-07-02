# frozen_string_literal: true

require 'rails_helper'

describe ResponseExporter do
  let!(:responseobj) do
    response_content = FactoryBot.create(:response_content,
                                         content: { 'v1' => 'slecht', 'v23_2a13_brood' => 'true', 'v3' => '23' })
    FactoryBot.create(:response, :completed, content: response_content.id.to_s)
  end

  context 'invalid questionnaire' do
    it 'raises an error' do
      expect { described_class.export_lines('not-a-questionnaire') }.to raise_error(RuntimeError,
                                                                                    'Questionnaire not found')
    end
  end

  context 'with redis caching' do
    describe 'export_headers' do
      it 'works correctly' do
        # create a response that should be filtered out
        person = FactoryBot.create(:student, :with_test_phone_number)
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
        FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: responseobj.measurement)
        questionnaire_key = responseobj.measurement.questionnaire.key
        expect(RedisCachedCall).to receive(:cache).with("questionnaire_headers_#{questionnaire_key}", false).and_yield
        export = described_class.export_headers(responseobj.measurement.questionnaire)
        expect(export).to eq(%w[response_id filled_out_by_id filled_out_for_id protocol_subscription_id] +
                             %w[measurement_id invitation_set_id open_from opened_at completed_at created_at] +
                             %w[updated_at v1 v3 v23_2a13_brood]) # Test the sorting of keys
      end
    end
  end

  context 'with valid questionnaire' do
    before do
      allow(RedisCachedCall).to receive(:cache).with(any_args).and_yield
    end

    it 'works with responses' do
      # create a response that should be filtered out
      person = FactoryBot.create(:student, :with_test_phone_number)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: responseobj.measurement)
      export = described_class.export_lines(responseobj.measurement.questionnaire.name).to_a.join.split("\n")

      expect(export.size).to eq 2
      expect(export.first).to match('"v1";"v3";"v23_2a13_brood"') # Test the sorting of keys
      expect(export.last.split(';', -1).first).to eq "\"#{responseobj.id}\""

      # External ids
      ids = Person.all.map { |p| p.external_identifier unless Exporters.test_phone_number? p.mobile_phone }
      id_col = export.last.split(';', -1).second
      expect(ids).to(be_any { |id| id_col.include? id })
      expect(id_col).to match(/\A"[a-z0-9]{4}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end

    it 'works without responses' do
      questionnaire_content = { questions: [{
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
      }], scores: [] }
      questionnaire = FactoryBot.create(:questionnaire, content: questionnaire_content)
      export = described_class.export_lines(questionnaire.name).to_a.join.split("\n")
      expect(export.size).to eq 1
      expect(export.last.split(';', -1).first).to eq '"response_id"'
      expect(export.last.split(';', -1).second).to eq '"filled_out_by_id"'
      expect(export.last.split(';', -1).last).to eq '"updated_at"'
    end
  end
end
