class AddFilledOutForToResponse < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :filled_out_for, references: :people 
    add_foreign_key :responses, :people, column: :filled_out_for_id  

    add_reference :responses, :filled_out_by, references: :people 
    add_foreign_key :responses, :people, column: :filled_out_by_id  

    Response.invited do |response|
      filled_out_for = response.protocol_subscription.filling_out_for
      filled_out_by = response.protocol_subscription.person

      response.filled_out_for = filling_out_for
      response.filled_out_by = filling_out_by
      response.save!
    end
    # Make sure we also update the students we already changed
  end
end
