class CreateRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :rewards do |t|
      t.integer :threshold, null: false
      t.integer :reward_points, null: false
      t.references :protocol, foreign_key: true, null: false

      t.timestamps
    end

    add_index :rewards, [:threshold, :protocol_id], name: 'index_rs_on_threshold_and_protocol_id', unique: true
  end
end
