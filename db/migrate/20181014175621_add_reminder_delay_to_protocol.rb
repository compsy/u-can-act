class AddReminderDelayToProtocol < ActiveRecord::Migration[5.0]
  def change
    add_column :protocols, :reminder_delay, :integer, null: true, default: 8.hours
  end
end
