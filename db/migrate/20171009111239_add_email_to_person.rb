class AddEmailToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :email, :string
  end
end
