# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @use_mentor_layout.nil?
    return 'mentor' if @use_mentor_layout
    'student'
  end
end
