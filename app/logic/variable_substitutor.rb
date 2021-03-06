# frozen_string_literal: true

class VariableSubstitutor
  class << self
    def substitute_variables(response)
      return {} if response.blank?

      student, mentor = response.determine_student_mentor
      create_substitution_hash(mentor, student)
    end

    def create_substitution_hash(mentor, student)
      {
        mentor_title: mentor&.role&.title,
        mentor_gender: mentor&.gender,
        mentor_name: mentor&.first_name,
        mentor_last_name: mentor&.last_name,
        organization: student.role.team.organization.name,
        student_name: student.first_name,
        student_last_name: student.last_name,
        student_gender: student.gender
      }
    end
  end
end
