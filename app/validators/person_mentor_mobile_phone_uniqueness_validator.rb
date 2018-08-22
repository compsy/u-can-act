# frozen_string_literal: true

class PersonMentorMobilePhoneUniquenessValidator < ActiveModel::Validator
  def validate(record)
    return unless record.person
    record.person.reload
    supervised = record.person.my_students
    return record if record.for_myself? || supervised.blank?
    students = mentor_protocols_with_this_phone_number(supervised, record.filling_out_for.mobile_phone)
    return record unless supervises_students_with_this_mobile_phone? students
    return record unless supervised_this_number_already? students, record
    record.errors.add(:filling_out_for_id, 'telefoonnummer is al in gebruik')
  end

  private

  def supervises_students_with_this_mobile_phone?(supervised_students)
    !supervised_students.blank?
  end

  def supervised_this_number_already?(supervised_students, record)
    !supervised_students.all? { |supervised| supervised == record.filling_out_for }
  end

  def mentor_protocols_with_this_phone_number(supervised, mobile_phone)
    supervised.select { |stud| stud.mobile_phone == mobile_phone }
  end
end
