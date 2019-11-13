class MakeAuth0StringUnique < ActiveRecord::Migration[5.1]
  def change
    change_column_null :auth_users, :auth0_id_string, false
    add_index :auth_users, :auth0_id_string, unique: true
  end
end
