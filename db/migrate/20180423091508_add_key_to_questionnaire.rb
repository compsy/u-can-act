class AddKeyToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :key, :string, null: true
    Questionnaire.find_each do |questionnaire|
      questionnaire.key = questionnaire.name.parameterize.underscore
      questionnaire.save! 
    end
    change_column_null :questionnaires, :key, false
  end
end
