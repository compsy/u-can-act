class CreateProtocolSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :protocol_subscriptions do |t|
      t.references :person, index: true, foreign_key: true, null: false
      t.references :protocol, index: true, foreign_key: true, null: false
      t.string :state, null: false
      t.datetime :start_date, null: false

      t.timestamps
    end
  end
end
