class AddRestrictedToOneTimeResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :one_time_responses, :restricted, :boolean, null: false, default: false
  end
end
