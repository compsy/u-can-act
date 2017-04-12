class CreateProtocols < ActiveRecord::Migration[5.0]
  def change
    create_table :protocols do |t|
      t.string :name, null: false
      t.integer :duration, null: false

      t.timestamps
    end
    add_index :protocols, :name, unique: true
  end
end
