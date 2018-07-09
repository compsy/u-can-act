# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscriptionExporter do
  it_should_behave_like 'an object_exporter object'

  context 'without protocol subscriptions' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with protocol subscriptions' do
    before do
      FactoryBot.create(:student, :with_protocol_subscriptions)
      FactoryBot.create(:mentor, :with_protocol_subscriptions)
      # create a response that should be filtered out
      person = FactoryBot.create(:student, :with_test_phone_number)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription)
    end

    it 'works with protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 3

      # External ids
      ids = Person.all.map { |p| p.external_identifier unless Exporters.test_phone_number? p.mobile_phone }
      id_col = export.last.split(';', -1).second
      expect(ids.any? { |id| id_col.include? id }).to be_truthy
      expect(id_col).to match(/\A"[a-z0-9]{4}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
  end
end
