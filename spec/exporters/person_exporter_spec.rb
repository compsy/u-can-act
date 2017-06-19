# frozen_string_literal: true

require 'rails_helper'

describe PersonExporter do
  context 'without people' do
    it 'works without people' do
      expect { |b| PersonExporter.export(&b) }.to yield_control.exactly(1).times
    end
  end

  context 'with people' do
    before do
      FactoryGirl.create :student
    end
    it 'works with people' do
      expect { |b| PersonExporter.export(&b) }.to yield_control.exactly(2).times
      export = []
      PersonExporter.export do |line|
        export << line
      end
      expect(export.size).to eq 2
      # bubblebabble format for first field (profile_id)
      expect(export.last.split(';').first).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';').size).to eq export.first.split(';').size
    end
  end
end
