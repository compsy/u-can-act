# frozen_string_literal: true

class VariableSubstitutor
  class << self
    def substitute_variables(response)
      student, mentor = response.determine_student_mentor
      create_substitution_hash(mentor, student)
    end

    def create_substitution_hash(mentor, student)
      {
        mentor_title: mentor&.role&.title,
        mentor_gender: mentor&.gender,
        mentor_name: mentor&.first_name,
        organization: student.role.team.organization.name,
        student_name: student.first_name,
        student_gender: student.gender
      }
    end
  end
end
