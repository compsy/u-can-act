class AddPropsToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :stop_measurement, :boolean, null: false, default: false
    add_column :measurements, :send_invite, :boolean, null: false, default: true
  end
end
