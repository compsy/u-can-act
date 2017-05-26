class AddTitleToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :title, :string
  end
end
