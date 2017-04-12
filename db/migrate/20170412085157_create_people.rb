class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :type, null: false # single table inheritance
      t.string :mobile_phone, null: false

      t.timestamps
    end
    add_index :people, :mobile_phone, unique: true
  end
end
