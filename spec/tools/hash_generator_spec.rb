# frozen_string_literal: true

require 'rails_helper'

describe HashGenerator do
  describe 'self.generate' do
    it 'should only hash plaintext if no salt is provided' do
      expected = '9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08'
      result = described_class.generate('test')
      expect(result.upcase).to eq expected
    end

    it 'should hash plaintext and the salt if a salt is provided' do
      expected = 'ECD71870D1963316A97E3AC3408C9835AD8CF0F3C1BC703527C30265534F75AE'
      result = described_class.generate('test', salt: 123)
      expect(result.upcase).to eq expected
    end
  end
end
