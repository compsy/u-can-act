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
  end
end
