# frozen_string_literal: true

class PersonMentorMobilePhoneUniquenessValidator < ActiveModel::Validator
  def validate(record)
    record.person.reload
    supervised = record.person.my_students
    return if record.for_myself? || supervised.blank?
    return unless supervised.any? { |stud| stud.mobile_phone == record.filling_out_for.mobile_phone }
    record.errors.add(:filling_out_for_id, 'telefoonnummer is al in gebruik')
  end
end
