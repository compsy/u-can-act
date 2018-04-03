# frozen_string_literal: true

require 'rails_helper'

describe RedisOverviewJob do
  describe 'run' do
    it 'should call the Teamoverview function with the correct parameters' do
      expect(Team).to receive(:overview).with(bust_cache: true)
      described_class.run
    end
  end
end
