class AddLanguageQuestionnaireToProtocol < ActiveRecord::Migration[6.1]
  def change
    add_reference :protocols, :language_questionnaire, index: true, foreign_key: { to_table: :questionnaires }
  end
end
