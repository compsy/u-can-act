class MakeQuestionnaireKeysUnique < ActiveRecord::Migration[5.0]
  def change
    remove_index :questionnaires, name: 'questionnaires_key'
    add_index :questionnaires, :key, name: 'questionnaires_key', unique: true
  end
end
