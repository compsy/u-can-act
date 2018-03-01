class CreateInvitationSets < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_sets do |t|
      t.references :person, index: true, foreign_key: true, null: false
      t.string :invitation_text, null: true

      t.timestamps
    end
    add_column :responses, :invitation_set_id, :integer, foreign_key: true, null: true
  end
end
