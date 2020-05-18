# frozen_string_literal: true

require 'rails_helper'

describe ConversionHelper do
  describe 'str_or_num_to_num' do
    it 'returns nil if the value is a string without numeric representation' do
      expect(helper.str_or_num_to_num('ando')).to be_nil
      expect(helper.str_or_num_to_num('an5do')).to be_nil
    end
    it 'returns nil if the value is blank' do
      expect(helper.str_or_num_to_num('')).to be_nil
      expect(helper.str_or_num_to_num(nil)).to be_nil
    end
    it 'returns the value if the value is a string representation of a number' do
      # test float pos
      expect(helper.str_or_num_to_num('5.5')).to eq(5.5)
      expect(helper.str_or_num_to_num('5.5').class).to eq Float
      # float neg
      expect(helper.str_or_num_to_num('-3.354243')).to eq(-3.354243)
      expect(helper.str_or_num_to_num('-3.354243').class).to eq Float
      # int pos
      expect(helper.str_or_num_to_num('17')).to eq(17)
      expect(helper.str_or_num_to_num('17').class).to eq Integer
      # int neg
      expect(helper.str_or_num_to_num('-3001')).to eq(-3001)
      expect(helper.str_or_num_to_num('-3001').class).to eq Integer
      # starting with the dot only
      expect(helper.str_or_num_to_num('.17')).to eq(0.17)
    end
    it 'returns an integer if the string value is a number like 1.0' do
      expect(helper.str_or_num_to_num('1.0')).to eq(1)
      expect(helper.str_or_num_to_num('1.0').class).to eq Integer
      expect(helper.str_or_num_to_num('-231.0')).to eq(-231)
      expect(helper.str_or_num_to_num('-231.0').class).to eq Integer
      expect(helper.str_or_num_to_num('0')).to eq 0
      expect(helper.str_or_num_to_num('0').class).to eq Integer
      expect(helper.str_or_num_to_num('-0')).to eq 0
      expect(helper.str_or_num_to_num('-0').class).to eq Integer
      expect(helper.str_or_num_to_num('0.0')).to eq 0
      expect(helper.str_or_num_to_num('0.0').class).to eq Integer
      expect(helper.str_or_num_to_num('-0.0')).to eq 0
      expect(helper.str_or_num_to_num('-0.0').class).to eq Integer
    end
  end

  describe 'number_to_string' do
    it 'returns a string numeric representation of the given integer' do
      # pos
      expect(helper.number_to_string(365)).to eq '365'
      # neg
      expect(helper.number_to_string(-14)).to eq '-14'
      # zero
      expect(helper.number_to_string(0)).to eq '0'
    end
    it 'returns a string numeric representation of the given float' do
      # pos
      expect(helper.number_to_string(22.7)).to eq '22.7'
      expect(helper.number_to_string(22.799)).to eq '22.799'
      expect(helper.number_to_string(22.79900)).to eq '22.799'
      expect(helper.number_to_string(22.000009)).to eq '22.000009'
      expect(helper.number_to_string(22.700)).to eq '22.7'
      # neg
      expect(helper.number_to_string(-22.7)).to eq '-22.7'
      expect(helper.number_to_string(-22.799)).to eq '-22.799'
      expect(helper.number_to_string(-22.79900)).to eq '-22.799'
      expect(helper.number_to_string(-22.000009)).to eq '-22.000009'
      expect(helper.number_to_string(-22.700)).to eq '-22.7'
    end
    it 'strips the .0 part of a float' do
      expect(helper.number_to_string(0.0)).to eq '0'
      expect(helper.number_to_string(-0.0)).to eq '0'
      expect(helper.number_to_string(0)).to eq '0'
      expect(helper.number_to_string(-0)).to eq '0'
      expect(helper.number_to_string(1.0)).to eq '1'
      expect(helper.number_to_string(-2.0)).to eq '-2'
    end
  end
end
