# frozen_string_literal: true

class AddUuidToResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :uuid, :string, limit: 36
    Response.find_each { |response| response.save! }
    change_column_null :responses, :uuid, false
    add_index :responses, :uuid, unique: true
  end
end
