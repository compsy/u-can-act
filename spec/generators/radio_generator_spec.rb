# frozen_string_literal: true

require 'rails_helper'

describe RadioGenerator do
  let!(:question) do
    {
      section_start: 'Algemeen',
      id: :v1,
      type: :radio,
      title: 'Hoe voelt u zich vandaag?',
      options: %w[slecht goed]
    }
  end

  let(:previous_response) { { v1: 'slecht' } }

  it_behaves_like 'a generator'
  it_behaves_like 'a checkable generator'
end
