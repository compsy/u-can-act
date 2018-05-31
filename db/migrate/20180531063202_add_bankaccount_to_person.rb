class AddBankaccountToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :bankaccount, :string, null: true
  end
end
