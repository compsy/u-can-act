class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :auth0_id_string, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :admins, :auth0_id_string, unique: true
  end
end
