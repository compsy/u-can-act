# frozen_string_literal: true

require 'rails_helper'

describe RandomResponseGenerator do
  include ConversionHelper
  # The following types are currently unsupported/not tested:
  # :drawing, :time, :expandable
  let(:questions) do
    [
      {
        type: :raw,
        content: 'Is dit een raw?'
      },
      {
        id: :v1,
        type: :checkbox,
        title: 'Is dit een checkbox?',
        required: true,
        show_otherwise: false,
        options: %w[check-a]
      },
      {
        id: :v2,
        type: :radio,
        title: 'Is dit een radio?',
        options: %w[radio-a radio-b]
      },
      {
        id: :v3,
        type: :likert,
        title: 'Is dit een likert?',
        options: %w[likert-a likert-b]
      },
      {
        id: :v4,
        type: :dropdown,
        title: 'Is dit een dropdown?',
        options: %w[dropdown-a dropdown-b]
      },
      {
        id: :v5,
        type: :range,
        title: 'Is dit een range?',
        labels: %w[range-a range-b]
      },
      {
        id: :v6,
        type: :textfield,
        title: 'Is dit een textfield?'
      },
      {
        id: :v7,
        type: :textarea,
        title: 'Is dit een textarea?'
      },
      {
        id: :v8,
        type: :number,
        title: 'Is dit een number?'
      },
      {
        id: :v9,
        type: :date,
        title: 'Is dit een date?'
      }
    ]
  end
  let(:questionnaire_content) { { questions: questions, scores: [] } }

  describe 'generate' do
    it 'generates a random response' do
      ids_with_numerical_answers = %w[v5 v8 v9]
      ids_with_text_answers = %w[v1_check_a v2 v3 v4 v6 v7]
      cnt = 0
      10.times do
        response = described_class.generate(questionnaire_content)
        expect(response.size).to eq(questionnaire_content[:questions].size - 1)
        expect(response.keys).to match_array(ids_with_numerical_answers + ids_with_text_answers)
        ids_with_numerical_answers.each do |cid|
          expect(response[cid]).to be_present
          expect(str_or_num_to_num(response[cid])).to be_present
        end
        ids_with_text_answers.each do |cid|
          expect(response[cid]).to be_present
          expect(str_or_num_to_num(response[cid])).to be_blank
          question = questionnaire_content[:questions].find { |qstn| qstn.key?(:id) && qstn[:id].to_s == cid }
          cnt += 1 if question.present? && question.key?(:options)
          expect(question[:options]).to include(response[cid]) if question.present? && question.key?(:options)
        end
        expect(response['v9']).to match(/\A[0-9]{4}(-[0-9]{2}){2}\z/)
        expect(response['v1_check_a']).to eq 'true'
      end
      expect(cnt).to eq(3 * 10)
    end
  end
end
