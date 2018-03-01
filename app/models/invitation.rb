# frozen_string_literal: true

class Invitation < ApplicationRecord
  NOT_SENT_STATE = 'not_sent'
  SENDING_STATE = 'sending'
  SENT_STATE = 'sent'
  SENDING_REMINDER_STATE = 'sending_reminder'
  REMINDER_SENT_STATE = 'reminder_sent'

  belongs_to :invitation_set
  validates :invitation_set_id, presence: true
  validates :type, presence: true
  validates :invited_state, inclusion: { in: [NOT_SENT_STATE,
                                              SENDING_STATE,
                                              SENT_STATE,
                                              SENDING_REMINDER_STATE,
                                              REMINDER_SENT_STATE] }

  def sending!
    new_invited_state = if invited_state == NOT_SENT_STATE
                          SENDING_STATE
                        else
                          SENDING_REMINDER_STATE
                        end
    update_attributes!(invited_state: new_invited_state)
  end

  def sent!
    new_invited_state = if invited_state == SENDING_STATE
                          SENT_STATE
                        else
                          REMINDER_SENT_STATE
                        end
    update_attributes!(invited_state: new_invited_state)
  end

  def send(_plain_text_token)
    raise 'send(...) method not implemented by subclass'
  end

  def generate_message(plain_text_token)
    "#{invitation_set.invitation_text} #{invitation_url(plain_text_token)}"
  end

  def invitation_url(plain_text_token)
    # TODO: FIX ME
    "#{ENV['HOST_URL']}/?q=#{plain_text_token}"
  end
end
