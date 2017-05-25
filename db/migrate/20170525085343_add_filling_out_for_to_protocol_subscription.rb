class AddFillingOutForToProtocolSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :protocol_subscriptions, :filling_out_for_id, :integer, foreign_key: true, null: false
  end
end
