# frozen_string_literal: true

require 'rails_helper'

describe DistributionHelper do
  describe 'number_to_string' do
    it 'works with integers' do
      expect(helper.number_to_string(15)).to eq '15'
      expect(helper.number_to_string(-2)).to eq '-2'
      expect(helper.number_to_string(0)).to eq '0'
      expect(helper.number_to_string(2.0)).to eq '2'
      expect(helper.number_to_string(2.00)).to eq '2'
      expect(helper.number_to_string(-3.000)).to eq '-3'
    end
    it 'works with floats' do
      expect(helper.number_to_string(0.5)).to eq '0.5'
      expect(helper.number_to_string(1.5)).to eq '1.5'
      expect(helper.number_to_string(1.50)).to eq '1.5'
      expect(helper.number_to_string(1.05)).to eq '1.05'
      expect(helper.number_to_string(1.050)).to eq '1.05'
      expect(helper.number_to_string(-2.42)).to eq '-2.42'
      expect(helper.number_to_string(-2.40)).to eq '-2.4'
    end
  end
end
