class AddTokenHashToInvitationToken < ActiveRecord::Migration[5.0]
  def change
    add_column :invitation_tokens, :token_hash, :string
    add_column :invitation_tokens, :expires_at, :datetime
    remove_column :invitation_tokens, :token
  end
end
