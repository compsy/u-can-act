class AddReminderDelayToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :reminder_delay, :integer, null: true, default: 8.hours
  end
end
