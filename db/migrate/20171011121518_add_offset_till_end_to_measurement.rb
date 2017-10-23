class AddOffsetTillEndToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :offset_till_end, :integer, null: true
  end
end
