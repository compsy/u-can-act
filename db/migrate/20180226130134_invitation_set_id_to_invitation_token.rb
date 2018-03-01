class InvitationSetIdToInvitationToken < ActiveRecord::Migration[5.0]
  def change
    add_column :invitation_tokens, :expires_at, :datetime, null: true
    add_column :invitation_tokens, :invitation_set_id, :integer, foreign_key: true, null: true
    InvitationToken.all.each do |invitation_token|
      invitation_token.update_attributes(expires_at: TimeTools.increase_by_duration(Time.zone.now,7.days),
                                         invitation_set: Response.find(invitation_token.response_id).invitation_set)
    end
    change_column_null :invitation_tokens, :expires_at, false
    change_column_null :invitation_tokens, :invitation_set_id, false
    remove_column :invitation_tokens, :response_id
  end
end
