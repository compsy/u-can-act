class AddInvitationTextsToProtocolSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :protocol_subscriptions, :invitation_text_nl, :string, null: true
    add_column :protocol_subscriptions, :invitation_text_en, :string, null: true
  end
end
