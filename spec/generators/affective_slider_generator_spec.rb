# frozen_string_literal: true

require 'rails_helper'

describe AffectiveSliderGenerator do
  let!(:question) do
    {
      section_start: 'Affect',
      id: :v1,
      type: :affective_slider,
      variant: :pleasure,
      required: true,
      title: 'Move the slider to rate your level of Pleasure',
      labels: %w[Unhappy Happy],
      section_end: true
    }
  end

  it_behaves_like 'a generator'

  describe 'generate' do
    let(:result) { subject.generate(question) }

    it 'reuses the range container so that the range javascript keeps working' do
      expect(result).to include 'class="range-container notchanged required"'
      expect(result).to include 'type="range"'
      expect(result).to include 'name="content[v1]"'
      expect(result).to include 'min="0"'
      expect(result).to include 'max="100"'
    end

    it 'shows the wedge' do
      expect(result).to include 'class="affective-slider-wedge"'
      expect(result).to match(%r{src="/assets/affective_slider/wedge[^"]*\.svg"})
    end

    it 'shows the labels with the values of the ends of the slider' do
      expect(result).to match(/data-value="0"[^>]*>.*Unhappy/)
      expect(result).to match(/data-value="100"[^>]*>.*Happy/)
    end

    it 'shows the images of the pleasure variant' do
      expect(result).to match(%r{src="/assets/affective_slider/unhappy[^"]*\.svg"})
      expect(result).to match(%r{src="/assets/affective_slider/happy[^"]*\.svg"})
    end

    it 'shows the images of the activation variant' do
      result = subject.generate(question.merge(variant: 'activation'))
      expect(result).to match(%r{src="/assets/affective_slider/calm_heart[^"]*\.svg"})
      expect(result).to match(%r{src="/assets/affective_slider/racing_heart[^"]*\.svg"})
    end

    it 'uses the min and max of the question for the values of the labels' do
      result = subject.generate(question.merge(min: -10, max: 10))
      expect(result).to match(/data-value="-10"[^>]*>.*Unhappy/)
      expect(result).to match(/data-value="10"[^>]*>.*Happy/)
    end

    it 'is never a vertical slider' do
      result = subject.generate(question.merge(vertical: true))
      expect(result).not_to include 'vertical-range'
      expect(result).to include 'class="affective-slider-wedge"'
    end

    it 'raises an error for an unknown variant' do
      expect { subject.generate(question.merge(variant: :dominance)) }
        .to raise_error(/Unknown affective slider variant :dominance/)
    end

    it 'raises an error without a variant' do
      expect { subject.generate(question.except(:variant)) }.to raise_error(/Unknown affective slider variant nil/)
    end
  end
end
