class AddLocaleRetrievedToInvitationSet < ActiveRecord::Migration[6.1]
  def change
    add_column :invitation_sets, :locale_retrieved, :boolean, default: false, null: false
  end
end
