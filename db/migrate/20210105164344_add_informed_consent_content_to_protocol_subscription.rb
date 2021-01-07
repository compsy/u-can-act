class AddInformedConsentContentToProtocolSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :protocol_subscriptions, :informed_consent_content, :string, null: true
  end
end
