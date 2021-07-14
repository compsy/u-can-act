class AddEndDateToProtocolSubscription < ActiveRecord::Migration[5.0]
  def up
    add_column :protocol_subscriptions, :end_date, :datetime, null: true
    ProtocolSubscription.reset_column_information
    ProtocolSubscription.all.each do |protocol_subscription|
      protocol_subscription.update(end_date:
                                     TimeTools.increase_by_duration(protocol_subscription.start_date,
                                                                    protocol_subscription.protocol.duration))
    end
    change_column_null :protocol_subscriptions, :end_date, false
  end

  def down
    remove_column :protocol_subscriptions, :end_date
  end
end
