class RenameRoleToAccessLevel < ActiveRecord::Migration[5.1]
  def change
    rename_column :auth_users, :role, :access_level
  end
end
