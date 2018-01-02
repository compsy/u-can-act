class AddUuidToResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :uuid, :string, limit: 36
  end
end
