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

  it_should_behave_like 'a generator'
end
