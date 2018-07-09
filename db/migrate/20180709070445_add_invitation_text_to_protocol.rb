class AddInvitationTextToProtocol < ActiveRecord::Migration[5.0]
  def change
    add_column :protocols, :invitation_text, :string, null: true
  end
end
