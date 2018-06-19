# frozen_string_literal: true

class VariableSubstitutor
  class << self
    def substitute_variables(response)
      student, mentor = response.determine_student_mentor
      subs_hash = substitute_singular_variables(mentor, student)
      subs_hash.merge substitute_plural_variables(mentor, student)
    end

    private

    def substitute_singular_variables(mentor, student)
      {
        mentor_title: mentor&.role&.title,
        mentor_gender: mentor&.gender,
        mentor_name: mentor&.first_name,
        organization: student.role.team.organization.name,
        student_name: student.first_name,
        student_gender: student.gender
      }
    end

    def substitute_plural_variables(_mentor, student)
      {
        student_names: student&.my_students&.map(&:first_name),
        student_genders: student&.my_students&.map(&:gender)
      }
    end
  end
end
