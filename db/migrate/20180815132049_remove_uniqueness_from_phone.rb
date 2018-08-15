class RemoveUniquenessFromPhone < ActiveRecord::Migration[5.0]
  def change
    remove_index  :people, :mobile_phone
  end
end
