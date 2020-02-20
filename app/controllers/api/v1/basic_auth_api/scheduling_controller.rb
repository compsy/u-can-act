# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      # The scheduling controller allows for external controll on the scheduling of worker
      # jobs.
      # @author Researchable
      class SchedulingController < BasicAuthApiController
        def daily_at_one_am
          ReschedulingJob.perform_later
          created
        end

        def daily_at_two_am
          CompleteProtocolSubscriptions.run
          created
        end

        def daily_at_three_am
          CleanupInvitationTokens.run
          created
        end

        def daily_at_four_am
          no_content
        end

        def daily
          no_content
        end

        def hourly
          no_content
        end

        def thirty_minutely
          no_content
        end

        def five_minutely
          SendInvitations.run
          SnitchJob.perform_later
          created
        end

        def minutely
          no_content
        end
      end
    end
  end
end
