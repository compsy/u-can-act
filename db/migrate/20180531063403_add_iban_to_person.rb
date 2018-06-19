class AddIbanToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :iban, :string, null: true
  end
end
