class AddOrganizationsToOrganization < ActiveRecord::Migration[5.0]
  def change
    create_table :super_organizations, id: false do |t|
      t.integer 'sub_id', null: false
      t.integer 'super_id', null: false
    end
  end
end
