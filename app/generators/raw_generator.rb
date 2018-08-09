# frozen_string_literal: true

class RawGenerator < Generator
  def generate(question)
    question[:content].html_safe
  end
end
