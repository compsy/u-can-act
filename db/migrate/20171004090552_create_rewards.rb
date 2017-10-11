class CreateRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :rewards do |t|
      t.integer :threshold, null: false
      t.integer :reward_points, null: false
      t.references :protocol, foreign_key: true, null: false

      t.timestamps
    end
  end
end
