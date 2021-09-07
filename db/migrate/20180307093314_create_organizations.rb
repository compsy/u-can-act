class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_column :teams, :organization_id, :integer, foreign_key: true, null: true
    add_index :organizations, :name, unique: true

    Organization.reset_column_information
    Team.reset_column_information
    default_organization = Organization.create!(name: 'Default organization')

    Team.all.each do |team|
      team.update!(organization: default_organization)
    end

    change_column_null :teams, :organization_id, false
  end
end
