class AddOpenFromDayUsesStartDateOffsetToProtocolSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :protocol_subscriptions, :open_from_day_uses_start_date_offset, :boolean, null: false, default: false
  end
end
