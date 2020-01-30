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
        value = '3.0'
        distribution = {}
        helper.initialize_question(aquestion, value, distribution)
        expected = { v2: { '2.5' => { '_' => 0 }, '3.0' => { '_' => 0 },
                           '3.5' => { '_' => 0 }, '4.0' => { '_' => 0 } } }
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
  end
end
