# frozen_string_literal: true

class RawGenerator < QuestionTypeGenerator
  def generate(question)
    question[:content].html_safe
  end
end
