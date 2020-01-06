class ChangePushSubscriptionIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :push_subscriptions, :name
    add_index :push_subscriptions, [:protocol_id, :name], unique: true
  end
end
