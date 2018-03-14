class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :invitation_set, index: true, foreign_key: true, null: false
      t.string :type, null: false
      t.string :invited_state, null: false, default: 'not_sent'

      t.timestamps
    end
    # Save the invited state in an invitation set before removing it.
    Response.where.not(invited_state: 'not_sent').each do |response|
      invitation_set = InvitationSet.create!(person: response.protocol_subscription.person, responses: [response])
      SmsInvitation.create!(invitation_set: invitation_set, invited_state: response.invited_state)
    end
    remove_column :responses, :invited_state
  end
end
