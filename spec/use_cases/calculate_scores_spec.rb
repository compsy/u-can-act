# frozen_string_literal: true

require 'rails_helper'

describe CalculateScores do
  describe 'execute' do
    let(:content) do
      {
        'v1' => '25',
        'v2' => '26'
      }
    end
    let(:questionnaire) do
      {
        questions: [{ id: :v1, type: :number, title: 'title1' }, { id: :v2, type: :number, title: 'title2' }],
        scores: [{ id: :s1,
                   label: 'average of v1 and v2',
                   ids: %i[v1 v2],
                   operation: :average,
                   require_all: false,
                   round_to_decimals: 1 }]
      }
    end
    let(:scores) do
      {
        's1' => '25.5'
      }
    end

    it 'should enrich the content correctly' do
      expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
    end

    context 'rounding' do
      it 'should not round the result if the round_to_decimals is not given' do
        questionnaire[:scores] = [{ id: :s1,
                                    label: 'average of v1 and v2',
                                    ids: %i[v1 v2],
                                    operation: :average,
                                    require_all: false }]
        content = { 'v1' => '25.323434983' }
        scores = { 's1' => '25.323434983' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
        content = { 'v1' => '-17' }
        scores = { 's1' => '-17' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should round a float to an integer if round_to_decimals is 0' do
        questionnaire[:scores][0][:round_to_decimals] = 0
        scores = { 's1' => '26' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should round to the number of decimals specified' do
        questionnaire[:scores][0][:round_to_decimals] = 2
        content = { 'v1' => '25.326434983' }
        scores = { 's1' => '25.33' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end

    context 'sum' do
      it 'should not round the result if the round_to_decimals is not given' do
        questionnaire[:scores] = [{ id: :s1,
                                    label: 'average of v1 and v2',
                                    ids: %i[v1 v2],
                                    operation: :sum,
                                    require_all: false }]
        content = { 'v1' => '25', 'v2' => '27' }
        scores = { 's1' => '52' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
        content = { 'v1' => '-17' }
        scores = { 's1' => '-17' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end

    context 'missing values' do
      it 'should still continue if one of the values is missing' do
        questionnaire[:scores][0][:ids] = %i[v3 v4 v1 v2 v5]
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should not continue if the require_all option is present' do
        questionnaire[:scores][0][:ids] = %i[v1 v2 v3]
        questionnaire[:scores][0][:require_all] = true
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq({})
      end
      it 'but it should continue if all values are present' do
        questionnaire[:scores][0][:require_all] = true
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should not do anything if there are no values left' do
        content = {}
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq content
      end
    end

    context 'scores dependent on previous scores' do
      it 'can calculate a score based on previous scores' do
        content = { 'v1' => '0', 'v4' => '4.5', 'v5' => '8', 'v6' => '6' }
        questionnaire[:scores] = [{
          id: :s1,
          label: 'Positive excited',
          ids: %i[v1 v2 v3 v4],
          operation: :average,
          require_all: false
        }, {
          id: :s2,
          label: 'Positive not excited',
          ids: %i[v5 v6 v7 v8],
          operation: :average,
          round_to_decimals: 0,
          require_all: false
        }, {
          id: :s3,
          label: 'Positive',
          ids: %i[s1 s2],
          operation: :average,
          require_all: true,
          round_to_decimals: 3
        }]
        scores = { 's1' => '2.25', 's2' => '7', 's3' => '4.625' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'works with rounding' do
        content = { 'v1' => '0', 'v4' => '4.5', 'v5' => '8', 'v6' => '6' }
        questionnaire[:scores] = [{
          id: :s1,
          label: 'Positive excited',
          ids: %i[v1 v2 v3 v4],
          operation: :average,
          require_all: false
        }, {
          id: :s2,
          label: 'Positive not excited',
          ids: %i[v5 v6 v7 v8],
          operation: :average,
          round_to_decimals: 0,
          require_all: false
        }, {
          id: :s3,
          label: 'Positive',
          ids: %i[s1 s2],
          operation: :average,
          require_all: true,
          round_to_decimals: 2
        }]
        scores = { 's1' => '2.25', 's2' => '7', 's3' => '4.63' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'works with missing values' do
        content = { 'v1' => '0', 'v4' => '4.5', 'v5' => '8', 'v6' => '6' }
        questionnaire[:scores] = [{
          id: :s1,
          label: 'Positive excited',
          ids: %i[v1 v2 v3 v4],
          operation: :average,
          require_all: false
        }, {
          id: :s2,
          label: 'Positive not excited',
          ids: %i[v5 v6 v7 v8],
          operation: :average,
          round_to_decimals: 0,
          require_all: true
        }, {
          id: :s3,
          label: 'Positive',
          ids: %i[s1 s2],
          operation: :average,
          require_all: true,
          round_to_decimals: 3
        }]
        scores = { 's1' => '2.25' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'works with missing values if require_all is false' do
        content = { 'v1' => '0', 'v4' => '4.5', 'v5' => '8', 'v6' => '6' }
        questionnaire[:scores] = [{
          id: :s1,
          label: 'Positive excited',
          ids: %i[v1 v2 v3 v4],
          operation: :average,
          require_all: false,
          round_to_decimals: 2
        }, {
          id: :s2,
          label: 'Positive not excited',
          ids: %i[v5 v6 v7 v8],
          operation: :average,
          round_to_decimals: 0,
          require_all: true
        }, {
          id: :s3,
          label: 'Positive',
          ids: %i[s1 s2],
          operation: :average
        }]
        scores = { 's1' => '2.25', 's3' => '2.25' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end

    context 'numeric_value of options' do
      let(:content) do
        {
          'v1' => 'title1',
          'v2' => 'title2'
        }
      end
      let(:questionnaire) do
        {
          questions: [{ id: :v1, type: :dropdown, options: [{ title: 'title1', numeric_value: 25 }] },
                      { id: :v2, type: :radio, options: [{ title: 'title2', numeric_value: 26 }] }],
          scores: [{ id: :s1,
                     label: 'average of v1 and v2',
                     ids: %i[v1 v2],
                     operation: :average,
                     require_all: true,
                     round_to_decimals: 1 }]
        }
      end
      let(:scores) do
        {
          's1' => '25.5'
        }
      end

      it 'should enrich the content correctly' do
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should fail when a value cannot be converted to a numerical value' do
        content = { 'v1' => 'title2', 'v2' => 'title2' }
        scores = {}
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'should not fail when a value cannot be converted to a numerical value if require_all is not true' do
        content = { 'v1' => 'title2', 'v2' => 'title2' }
        scores = { 's1' => '26' }
        questionnaire[:scores].first[:require_all] = false
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end

    context 'score recalculation' do
      let(:content) do
        {
          'v1' => '25',
          's1' => '25.5'
        }
      end
      let(:questionnaire) do
        {
          questions: [{ id: :v1, type: :number, title: 'title1' }, { id: :v2, type: :number, title: 'title2' }],
          scores: [{ id: :s1,
                     label: 'average of v1 and v2',
                     ids: %i[v1 v2],
                     operation: :average,
                     require_all: true,
                     round_to_decimals: 1 }]
        }
      end
      let(:scores) do
        {}
      end
      it 'should remove previous score definitions' do
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end

    context 'preprocessing' do
      it 'is possible to have multiply_with preprocessing' do
        content = { 'v1' => 'title1', 'v2' => 'title2' }
        questionnaire = {
          questions: [{ id: :v1, type: :dropdown, options: [{ title: 'title1', numeric_value: 25 }] },
                      { id: :v2, type: :radio, options: [{ title: 'title2', numeric_value: 26 }] }],
          scores: [{ id: :s1,
                     label: 'average of v1 and v2',
                     ids: %i[v1 v2],
                     operation: :average,
                     require_all: true,
                     preprocessing: { v1: { multiply_with: 2 } },
                     round_to_decimals: 1 }]
        }
        scores = { 's1' => '38.0' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'is possible to have offset preprocessing' do
        content = { 'v1' => 'title1', 'v2' => 'title2' }
        questionnaire = {
          questions: [{ id: :v1, type: :dropdown, options: [{ title: 'title1', numeric_value: 25 }] },
                      { id: :v2, type: :radio, options: [{ title: 'title2', numeric_value: 26 }] }],
          scores: [{ id: :s1,
                     label: 'average of v1 and v2',
                     ids: %i[v1 v2],
                     operation: :average,
                     require_all: true,
                     preprocessing: { v1: { offset: -50.5 } },
                     round_to_decimals: 1 }] # 0.25 -> 0.3
        }
        scores = { 's1' => '0.3' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
      it 'is possible to have chained preprocessing' do
        content = { 'v1' => 'title1', 'v2' => 'title2' }
        questionnaire = {
          questions: [{ id: :v1, type: :dropdown, options: [{ title: 'title1', numeric_value: 25 }] },
                      { id: :v2, type: :radio, options: [{ title: 'title2', numeric_value: 26 }] }],
          scores: [{ id: :s1,
                     label: 'average of v1 and v2',
                     ids: %i[v1],
                     operation: :average,
                     require_all: true,
                     preprocessing: { v1: { offset: -23 } } }, # 2
                   { id: :s2,
                     label: 's1 processed',
                     ids: %i[s1],
                     operation: :average,
                     require_all: true,
                     preprocessing: { s1: { multiply_with: -3, offset: 11 } } }, # 5
                   { id: :s3,
                     label: 'average of s1 and s2',
                     ids: %i[s1 s2],
                     operation: :average,
                     require_all: true }, # 3.5
                   { id: :s4,
                     label: 'something with s3',
                     ids: %i[s3],
                     operation: :average,
                     require_all: true,
                     round_to_decimals: 0,
                     preprocessing: { s3: { multiply_with: 4, offset: -1 } } }] # 13
        }
        scores = { 's1' => '2', 's2' => '5', 's3' => '3.5', 's4' => '13' }
        expect(described_class.run!(content: content, questionnaire: questionnaire)).to eq scores
      end
    end
  end
end
