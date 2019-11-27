class CreatePushSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :push_subscriptions do |t|
      t.references :protocol, index: true, foreign_key: true, null: false
      t.string :url, null: false
      t.string :name, null: false
      t.string :method, null: false

      t.timestamps
    end
    add_index :push_subscriptions, :name, unique: true
  end
end
