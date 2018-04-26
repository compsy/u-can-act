class AddKeyToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :key, :string, null: true
    Questionnaire.find_each do |questionnaire|
      questionnaire.key = questionnaire.name.underscore.parameterize
      questionnaire.save! 
    end
    change_column_null :questionnaires, :key, false
    add_index :questionnaires, :key, name: "questionnaires_key"
  end
end
