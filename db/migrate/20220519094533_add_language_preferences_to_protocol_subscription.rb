class AddLanguagePreferencesToProtocolSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :protocol_subscriptions, :needs_language_input, :boolean, null: false, default: false
    add_column :protocol_subscriptions, :has_language_input, :boolean, null: false, default: false
  end
end
