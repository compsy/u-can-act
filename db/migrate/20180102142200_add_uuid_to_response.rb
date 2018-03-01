# frozen_string_literal: true

class AddUuidToResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :uuid, :string, limit: 36
    Response.all.each do |response|
      next if response.uuid
      response.uuid = SecureRandom.uuid
      response.uuid = SecureRandom.uuid while Response.where(uuid: response.uuid).count.positive?
      response.save!
    end
    change_column_null :responses, :uuid, false
    add_index :responses, :uuid, unique: true
  end
end
