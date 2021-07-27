class AddCollapseDuplicatesToMeasurement < ActiveRecord::Migration[6.1]
  def change
    add_column :measurements, :collapse_duplicates, :boolean, null: false, default: true
  end
end
