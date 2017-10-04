class CreateRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :rewards do |t|
      t.integer :threshold, null: false
      t.integer :reward_points, null: false

      t.timestamps
    end

    create_table :protocols_rewards, id: false do |t|
      t.belongs_to :protocol, index: true
      t.belongs_to :reward, index: true
    end
  end
end
