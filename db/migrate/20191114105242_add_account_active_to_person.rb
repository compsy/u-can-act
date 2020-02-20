class AddAccountActiveToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :account_active, :boolean, default: false, null: false
  end
end
