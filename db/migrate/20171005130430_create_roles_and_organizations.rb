class CreateRolesAndOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :gender, :string
    add_column :people, :email, :string
    
    create_table :organizations do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :organizations, :name, unique: true

    create_table :roles do |t|
      t.string :group, null: false
      t.string :title, null: false
      t.references :organization, foreign_key: true, null: false

      t.timestamps
    end
    add_index :roles, [:organization_id, :title], unique: true

    add_column :people, :role_id, :integer, foreign_key: true, null: false
    remove_column :people, :type
  end
end
