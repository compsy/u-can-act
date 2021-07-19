class AddFillingOutForToProtocolSubscription < ActiveRecord::Migration[5.0]
  def up
    add_column :protocol_subscriptions, :filling_out_for_id, :integer, foreign_key: true, null: true
    ProtocolSubscription.reset_column_information
    ProtocolSubscription.all.each do |protocol_subscription|
      protocol_subscription.update(filling_out_for_id: protocol_subscription.person_id)
    end
    change_column_null :protocol_subscriptions, :filling_out_for_id, false
  end

  def down
    remove_column :protocol_subscriptions, :filling_out_for_id
  end
end
