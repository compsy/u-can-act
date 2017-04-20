class CreateInvitationTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_tokens do |t|
      t.references :response, index: { unique: true }, foreign_key: true, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :invitation_tokens, :token, unique: true
  end
end
