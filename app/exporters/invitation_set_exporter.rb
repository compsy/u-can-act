# frozen_string_literal: true

class InvitationSetExporter < ObjectExporter
  class << self
    def klass
      InvitationSet
    end

    def default_fields
      %w[invitation_text]
    end

    def formatted_fields
      %w[invitation_set_id person_id created_at updated_at]
    end

    def format_fields(invitation_set)
      {
        'invitation_set_id' => invitation_set.id,
        'person_id' => invitation_set.person.external_identifier,
        'created_at' => format_datetime(invitation_set.created_at),
        'updated_at' => format_datetime(invitation_set.updated_at)
      }
    end

    def to_be_skipped?(invitation_set)
      invitation_set.person.mobile_phone
      Exporters.test_phone_number?(invitation_set.person.mobile_phone)
    end
  end
end
