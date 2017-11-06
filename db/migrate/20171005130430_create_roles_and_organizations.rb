class CreateRolesAndOrganizations < ActiveRecord::Migration[5.0]
  def change
    rename_column :people, :type, :role_type
    
    create_table :organizations do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :organizations, :name, unique: true
    default_organization = Organization.create(name: 'Default organization')

    create_table :roles do |t|
      t.string :group, null: false
      t.string :title, null: false
      t.references :organization, foreign_key: true, null: false

      t.timestamps
    end
    add_index :roles, [:organization_id, :title], unique: true

    Organization.all.each do |organization|
      Role.create!(organization: organization, group: Person::MENTOR, title: Person::MENTOR)
      Role.create!(organization: organization, group: Person::STUDENT, title: Person::STUDENT)
    end

    add_column :people, :role_id, :integer, foreign_key: true, null: true

    Person.all.each do |person|
      role = Organization.find(person.organization_id).roles.find_by_group(person.role_type)
      person.role = role
      person.organization_id = nil
      person.save!
    end

    change_column_null :people, :role_id, false
    remove_column :people, :role_type
  end
end
