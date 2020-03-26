class AddUniquenessToPeopleEmails < ActiveRecord::Migration[5.2]
  def change
    add_index :people, :email, unique: true
  end
end
