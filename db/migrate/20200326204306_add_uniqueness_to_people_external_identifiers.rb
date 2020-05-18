class AddUniquenessToPeopleExternalIdentifiers < ActiveRecord::Migration[5.2]
  def change
    add_index :people, :external_identifier, unique: true
  end
end
