class AddFilledOutForToResponse < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :filled_out_for, references: :people
    add_foreign_key :responses, :people, column: :filled_out_for_id

    add_reference :responses, :filled_out_by, references: :people
    add_foreign_key :responses, :people, column: :filled_out_by_id

    Person.reset_column_information
    Response.reset_column_information
    ProtocolSubscription.reset_column_information
    Response.where('invited_state=? OR invited_state=? OR invited_state=?',
                   'sent', 'sending_reminder', 'reminder_sent').find_each do |response|
      filled_out_for_id = response.protocol_subscription.filling_out_for_id
      filled_out_by_id = response.protocol_subscription.person_id

      response.update!(filled_out_for_id: filled_out_for_id,
                                  filled_out_by_id:  filled_out_by_id)
    end
  end
end
