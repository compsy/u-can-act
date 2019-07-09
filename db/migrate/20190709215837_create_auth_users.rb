class CreateAuthUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_users do |t|
      t.string :auth0_id_string
      t.string :password_digest
      t.string :role
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
