class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.references :questionnaire, index: true, foreign_key: true
      t.references :protocol, index: true, foreign_key: true
      t.integer :period
      t.integer :open_from_offset, null: false
      t.integer :open_duration
      t.integer :reward_points, default: 0, null: false

      t.timestamps
    end
  end
end
