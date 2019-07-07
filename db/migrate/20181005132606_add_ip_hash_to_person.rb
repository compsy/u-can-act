class AddIpHashToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :ip_hash, :string, null: true
  end
end
