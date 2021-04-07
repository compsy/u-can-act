class AddTemplateToPushSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :push_subscriptions, :template, :string, null: false, default: 'sdv'
  end
end
