class CreateRoles < ActiveRecord::Migration[5.0]
  def up
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
    change_column_null :people, :organization_id, true
    Person.all.each do |person|
      role = Organization.find(person.organization_id).roles.find_by_group(person.type)
      person.role = role
      person.organization_id = nil
      person.save!
    end

    remove_column :people, :organization_id
    remove_column :people, :type
    remove_column :organizations, :mentor_title
    change_column_null :people, :role_id, false
  end

  def down
    add_column :people, :organization_id, :integer, foreign_key: true, null: true
    add_column :people, :type, :string, foreign_key: true, null: true
    Person.all.each do |person|
      person.organization = person.role.organization
      person.type = person.role.group
      person.role = nil
      person.save!
    end

    remove_column :people, :role_id
    change_column_null :people, :type, false
    change_column_null :people, :organization_id, false
    drop_table :roles
  end
end
