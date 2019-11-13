class MakeAuth0StringUnique < ActiveRecord::Migration[5.1]
  def change
    change_column_null :auth_users, :auth0_id_string, false
    add_index :auth_users, :auth0_id_string, unique: true
    remove_index :protocol_subscriptions, name: 'index_rs_on_person_id_and_filling_out_for_id'
  end
end
