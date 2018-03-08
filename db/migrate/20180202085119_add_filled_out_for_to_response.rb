class AddFilledOutForToResponse < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :filled_out_for, references: :people
    add_foreign_key :responses, :people, column: :filled_out_for_id

    add_reference :responses, :filled_out_by, references: :people
    add_foreign_key :responses, :people, column: :filled_out_by_id

    Response.where('invited_state=? OR invited_state=? OR invited_state=?',
                   'sent', 'sending_reminder', 'reminder_sent') do |response|
      filled_out_for = response.protocol_subscription.filling_out_for
      filled_out_by = response.protocol_subscription.person

      response.filled_out_for = filled_out_for
      response.filled_out_by = filled_out_by
      response.save!
    end
  end
end
