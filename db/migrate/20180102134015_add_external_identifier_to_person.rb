class AddExternalIdentifierToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :external_identifier, :string
  end
end
