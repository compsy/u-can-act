# frozen_string_literal: true

module ApplicationHelper
  def student_mentor_class
    return '' if @is_mentor.nil?
    return 'mentor' if @is_mentor
    'student'
  end
end
