class AddPriorityToMeasurement < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :priority, :integer, null: true
  end
end
