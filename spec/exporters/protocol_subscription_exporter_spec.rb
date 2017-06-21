# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscriptionExporter do
  context 'without protocol subscriptions' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with protocol subscriptions' do
    before do
      FactoryGirl.create(:student, :with_protocol_subscriptions)
      FactoryGirl.create(:mentor, :with_protocol_subscriptions)
    end
    it 'works with protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 3
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';').second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';')[-2]).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';').size).to eq export.first.split(';').size
    end
  end
end
