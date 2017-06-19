# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscriptionExporter do
  context 'without protocol subscriptions' do
    it 'works without protocol subscriptions' do
      expect { |b| ProtocolSubscriptionExporter.export(&b) }.to yield_control.exactly(1).times
    end
  end

  context 'with protocol subscriptions' do
    before do
      FactoryGirl.create(:student, :with_protocol_subscriptions)
    end
    it 'works with protocol subscriptions' do
      expect { |b| ProtocolSubscriptionExporter.export(&b) }.to yield_control.exactly(2).times
      export = []
      ProtocolSubscriptionExporter.export do |line|
        export << line
      end
      expect(export.size).to eq 2
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';').second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';')[-2]).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';').size).to eq export.first.split(';').size
    end
  end
end
