class AddExternalIdentifierToProtocolSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :protocol_subscriptions, :external_identifier, :string, null: true
  end
end
