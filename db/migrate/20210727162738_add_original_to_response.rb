class AddOriginalToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :original, :boolean, default: true, null: false
  end
end
