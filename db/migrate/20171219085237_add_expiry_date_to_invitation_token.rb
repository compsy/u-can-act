class AddExpiryDateToInvitationToken < ActiveRecord::Migration[5.0]
  def change
    add_column :invitation_tokens, :expiry_date, :datetime
  end
end
