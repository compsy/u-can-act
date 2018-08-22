# frozen_string_literal: true

class SupervisionTrajectory < ApplicationRecord
  belongs_to :protocol_for_mentor, class_name: 'Protocol'
  belongs_to :protocol_for_student, class_name: 'Protocol'
  validates :name, presence: true, uniqueness: true

  validates :protocol_for_mentor, uniqueness: { scope: :protocol_for_student }, allow_blank: true

  def subscribe!(mentor:, student:, start_date:, end_date:)
    subscribe_student(student, start_date, end_date)
    subscribe_mentor(student, mentor, start_date, end_date)
  end

  private

  def subscribe_student(student, start_date, end_date)
    return unless protocol_for_student
    ProtocolSubscription.create!(person: student,
                                 protocol: protocol_for_student,
                                 state: ProtocolSubscription::ACTIVE_STATE,
                                 start_date: start_date,
                                 end_date: end_date)
  end

  def subscribe_mentor(student, mentor, start_date, end_date)
    return unless protocol_for_mentor
    ProtocolSubscription.create!(person: mentor,
                                 filling_out_for: student,
                                 protocol: protocol_for_mentor,
                                 state: ProtocolSubscription::ACTIVE_STATE,
                                 start_date: start_date,
                                 end_date: end_date)
  end
end
