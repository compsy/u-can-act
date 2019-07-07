# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireQuestionGenerator do
  describe 'generate' do
    it 'throws an unknown question type error whenever the question does not exist' do
      question = {
        id: :v1,
        type: :weird_question_type
      }
      expect { subject.generate(question) }.to raise_error RuntimeError, 'Unknown question type weird_question_type'
    end

    it 'throws an unknown question type error whenever the question is not allowed' do
      question = {
        id: :v1,
        type: :klasses
      }
      expect { subject.generate(question) }.to raise_error RuntimeError, 'Question type klasses not allowed as question'
    end
  end
end
