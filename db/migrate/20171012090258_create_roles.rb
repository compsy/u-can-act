class CreateRoles < ActiveRecord::Migration[5.0]
  def up
    create_table :roles do |t|
      t.string :type, null: false
      t.string :title, null: false
      t.references :organization, foreign_key: true, null: false

      t.timestamps
    end

    Organization.all.each do |organization|
      Role.create!(organization: organization, type: 'Mentor', title: 'Mentor')
      Role.create!(organization: organization, type: 'Student', title: 'Student')
    end

    add_column :people, :role_id, :integer, foreign_key: true, null: true
    Person.all.each do |person|
      person.role = person.organization.roles.find_by_type(person.type)
      person.organization = nil
      person.save!
    end
    remove_column :people, :organization_id
    remove_column :people, :type
  end

  def down
    remove_column :people, :role_id
    drop_table :roles
  end
end
