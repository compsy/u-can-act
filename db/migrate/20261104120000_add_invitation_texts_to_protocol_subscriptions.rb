# frozen_string_literal: true

# Invitation texts per locale ({ "nl" => "...", "fi" => "..." }). The nl and en texts stay in invitation_text_nl/en
# for now, so no backfill is needed; see ProtocolSubscription#all_invitation_texts.
class AddInvitationTextsToProtocolSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :protocol_subscriptions, :invitation_texts, :jsonb, default: {}, null: false
  end
end
