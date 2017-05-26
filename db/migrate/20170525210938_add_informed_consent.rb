class AddInformedConsent < ActiveRecord::Migration[5.0]
  def change
    add_reference :protocols, :informed_consent_questionnaire, index: true, foreign_key: { to_table: :questionnaires }
    add_column :protocol_subscriptions, :informed_consent_given_at, :datetime
  end
end
