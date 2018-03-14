class AddFilledOutForToResponseData < ActiveRecord::Migration[5.0]
  def change
    Response.where('invited_state=? OR invited_state=? OR invited_state=?',
                   'sent', 'sending_reminder', 'reminder_sent').each do |response|
      filled_out_for_id = response.protocol_subscription.filling_out_for_id
      filled_out_by_id = response.protocol_subscription.person_id

      response.update_attributes!(filled_out_for_id: filled_out_for_id,
                                  filled_out_by_id:  filled_out_by_id)
    end
  end
end
