# frozen_string_literal: true

require 'rails_helper'

describe AsyncActiveInteraction do
  describe 'run_async!' do
    it 'calls AsycnActiveInteractionJob' do
      expected = Marshal.dump([{ one: 3, two: 4, three: Time.zone.now.change(usec: 0) }])
      expect(AsyncActiveInteractionJob).to receive(:perform_later).with('AsyncActiveInteraction', expected)
      described_class.run_async!(one: 3, two: 4, three: Time.zone.now.change(usec: 0))
    end
  end
end
