# frozen_string_literal: true

class Generator
  include ActionView::Helpers

  def generate(_question)
    throw 'Generate not implemented!'
  end

  private

  def idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end
end
