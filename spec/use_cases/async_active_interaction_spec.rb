# frozen_string_literal: true

require 'rails_helper'

describe AsyncActiveInteraction do
  describe 'run_async!' do
    it 'calls AsycnActiveInteractionJob' do
      expect(AsyncActiveInteractionJob).to receive(:perform_later).with('AsyncActiveInteraction', one: 3, two: 4)
      described_class.run_async!(one: 3, two: 4)
    end
  end
end
