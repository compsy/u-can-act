class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :protocol_subscription, index: true, foreign_key: true, null: false
      t.references :measurement, index: true, foreign_key: true, null: false
      t.string :content
      t.datetime :open_from, null: false
      t.datetime :opened_at
      t.datetime :completed_at
      t.string :invited_state, null: false

      t.timestamps
    end
  end
end
