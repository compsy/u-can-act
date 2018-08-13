# frozen_string_literal: true

require 'rails_helper'

describe RadioGenerator do
  let (:question) do
    {
      section_start: 'Algemeen',
      id: :v1,
      type: :radio,
      title: 'Hoe voelt u zich vandaag?',
      options: %w[slecht goed]
    }
  end

  before :each do
    question[:raw] = question.deep_dup
  end

  describe 'generate' do
    it 'should generate the correct html' do
      result = subject.generate(question)
    end
  end
end
