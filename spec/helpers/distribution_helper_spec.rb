# frozen_string_literal: true

require 'rails_helper'

describe DistributionHelper do
  let(:question) do
    {
      section_start: 'De hoofddoelen',
      hidden: true,
      id: :v2,
      type: :range,
      min: 0,
      max: 100,
      step: 1,
      title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
      tooltip: 'some tooltip',
      labels: ['helemaal niet duidelijk', 'heel duidelijk'],
      section_end: true
    }
  end

  describe 'initialize_question' do
    context 'range type questions' do
      it 'works with integer ranges' do
        aquestion = question
        aquestion[:min] = 2
        aquestion[:max] = 5
        aquestion[:step] = 1
        value = '3'
        distribution = {}
        helper.initialize_question(aquestion, value, distribution)
        expected = { v2: { '2' => { '_' => 0 }, '3' => { '_' => 0 }, '4' => { '_' => 0 }, '5' => { '_' => 0 } } }
        expect(distribution).to eq expected
      end
      it 'works with non integer ranges' do
        aquestion = question
        aquestion[:min] = 2.5
        aquestion[:max] = 4
        aquestion[:step] = 0.5
        value = '3'
        distribution = {}
        helper.initialize_question(aquestion, value, distribution)
        expected = { v2: { '2.5' => { '_' => 0 }, '3' => { '_' => 0 },
                           '3.5' => { '_' => 0 }, '4' => { '_' => 0 } } }
        expect(distribution).to eq expected
      end
    end
    context 'other type questions' do
      it 'works with numbers' do
        aquestion = question
        question[:type] = :number
        value = '3'
        distribution = {}
        helper.initialize_question(aquestion, value, distribution)
        expected = { v2: { '3' => { '_' => 0 } } }
        expect(distribution).to eq expected
      end
    end
    context 'scores' do
      it 'works with scores' do
        aquestion = { id: :s1,
                      label: 'The average of v1 and v2',
                      ids: %i[v1 v2],
                      operation: :average,
                      require_all: true,
                      round_to_decimals: 0 }
        value = '3'
        distribution = {}
        helper.initialize_question(aquestion, value, distribution)
        expected = { s1: { '3' => { '_' => 0 } } }
        expect(distribution).to eq expected
      end
    end
  end

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
