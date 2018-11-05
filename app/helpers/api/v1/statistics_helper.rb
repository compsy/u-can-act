# frozen_string_literal: true

module Api
  module V1
    module StatisticsHelper
      def number_of_informed_consents_given(group)
        # If this method is used to count people then it is assumed that a person is asked
        # for informed consent in at most one of her protocols.
        group_role_ids = Role.where(group: group).pluck(:id)
        group_ids = Person.where(role: group_role_ids).pluck(:id)
        ProtocolSubscription
          .where('informed_consent_given_at IS NOT NULL')
          .where(person_id: group_ids)
          .group(:person_id).count.count
      end
    end
  end
end
