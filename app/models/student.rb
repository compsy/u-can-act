# frozen_string_literal: true

class Student < Person
  def mentor
    ProtocolSubscription.where(filling_out_for_id: id).where.not(person_id: id).first&.person
  end
end
