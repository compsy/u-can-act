class AddOpenFromDayToMeasurement < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :open_from_day, :string, null: true
  end
end
