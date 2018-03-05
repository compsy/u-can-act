class InvitationSetIdToInvitationToken < ActiveRecord::Migration[5.0]
  def change
    add_reference :invitation_tokens, :invitation_set
    add_foreign_key :invitation_tokens, :invitation_sets, column: :invitation_set_id
    InvitationToken.all.each do |invitation_token|
      invitation_token.update_attributes(invitation_set: Response.find(invitation_token.response_id).invitation_set)
    end
    change_column_null :invitation_tokens, :invitation_set_id, false
    remove_column :invitation_tokens, :response_id
  end
end
