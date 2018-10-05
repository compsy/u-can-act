class CreateOneTimeResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :one_time_responses do |t|
      t.string :token, null: false
      t.references :protocol, index: true, foreign_key: true, null: false

      t.timestamps
    end
    add_index :one_time_responses, :token, name: 'one_time_response_token', unique: true
  end
end
