class AddReminderDelayToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :reminder_delay, :integer, null: true, default: Measurement::DEFAULT_REMINDER_DELAY
  end
end
