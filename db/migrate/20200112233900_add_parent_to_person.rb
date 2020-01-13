class AddParentToPerson < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :parent, index: true
  end
end
