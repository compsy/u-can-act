class RenameOrganizationToTeam < ActiveRecord::Migration[5.0]
  def change
    rename_table :organizations, :teams
    rename_column :roles, :organization_id, :team_id
  end
end
