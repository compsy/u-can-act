# frozen_string_literal: true

require 'rails_helper'

describe RangeGenerator do
  let!(:question) do
    {
      section_start: 'De hoofddoelen',
      hidden: true,
      id: :v2,
      type: :range,
      min: 23,
      max: 36,
      step: 1,
      title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
      tooltip: 'some tooltip',
      labels: ['helemaal niet duidelijk', 'heel duidelijk'],
      section_end: true
    }
  end

  it_behaves_like 'a generator'

  describe 'range_slider_minmax' do
    it 'returns a hash with expected min and max values' do
      expect(subject.range_slider_minmax(question)).to eq(min: 23, max: 36)
    end
  end
end
