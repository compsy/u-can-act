class CreateOrganizations < ActiveRecord::Migration[5.0]
  def up
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :mentor_title

      t.timestamps
    end
    add_index :organizations, :name, unique: true
    default_organization = Organization.create(name: 'Default organization')
    add_column :people, :organization_id, :integer, foreign_key: true, null: true
    Person.all.each do |person|
      person.update_attributes(organization: default_organization)
    end
    change_column_null :people, :organization_id, false
  end

  def down
    remove_column :people, :organization_id
    drop_table :organizations
  end
end
