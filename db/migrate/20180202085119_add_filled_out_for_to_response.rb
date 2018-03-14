class AddFilledOutForToResponse < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :filled_out_for, references: :people
    add_foreign_key :responses, :people, column: :filled_out_for_id

    add_reference :responses, :filled_out_by, references: :people
    add_foreign_key :responses, :people, column: :filled_out_by_id
  end
end
