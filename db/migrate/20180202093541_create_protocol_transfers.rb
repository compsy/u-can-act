# frozen_string_literal: true

class CreateProtocolTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :protocol_transfers do |t|
      t.references :from, references: :person, null: false
      t.references :to, references: :person, null: false
      t.references :protocol_subscription, foreign_key: true, null: false

      t.timestamps
    end
    add_foreign_key :protocol_transfers, :people, column: :from_id
    add_foreign_key :protocol_transfers, :people, column: :to_id

    student1 = Person.find_by_mobile_phone('0637422582')
    student2 = Person.find_by_mobile_phone('0638736269')

    mentor_old = Person.find_by_mobile_phone('0613404142')
    mentor_new = Person.find_by_mobile_phone('0637422582')

    [student1, student2].each do |student|
      next unless student.present?
      prot = mentor_new.protocol_subscriptions.where(filling_out_for_id: student.id)
      transfer = ProtocolTransfer.create(from: mentor_old, to: mentor_new, protocol_subscription: prot)
      transfer.update_attributes!(created_at: Time.new(2017, 12, 20).in_time_zone)
    end
  end
end
