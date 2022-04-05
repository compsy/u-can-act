class AddPrefilledToMeasurement < ActiveRecord::Migration[6.1]
  def change
    add_column :measurements, :prefilled, :boolean, null: false, default: false
  end
end
