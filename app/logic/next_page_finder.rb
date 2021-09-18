# frozen_string_literal: true

class NextPageFinder
  class << self
    include Rails.application.routes.url_helpers

    # rubocop:disable Metrics/PerceivedComplexity
    def get_next_page(current_user:, previous_response: nil, next_response: nil, params: {})
      # if we just filled out a response
      if previous_response.present?
        if previous_response.measurement.redirect_url.present? &&
           !previous_response.measurement.only_redirect_if_nothing_else_ready?
          previous_response.measurement.redirect_url
        else
          # if we just filled out an otr response or a non-otr response,
          # rule: never redirect to an otr response (unless the next_reponse given as argument is an otr_response).
          # NOTE: here we choose to redirect to non-otr response even after filling out an otr response. we assume that
          # this is the desired behavior.

          # if there is a next non otr response ready and (i am not a mentor or it is filled out for myself)
          # (my_open_responses only returns non-OTR responses)
          next_response ||= current_user.my_open_responses(current_user.mentor?).first
          url_to_response_or_exit_flow(current_user, previous_response, next_response, params)
        end
      else
        # we did not just fill out a response.
        # only redirect back to redirect_url/klaar_path/mentor_overview_page if there is no response to redirect to

        # redirect to next non otr response (if there is one to be filled out for myself or i am not a mentor)
        next_response ||= current_user.my_open_responses(current_user.mentor?).first
        # otherwise redirect to next otr response
        next_response ||= current_user.all_my_open_one_time_responses.first
        url_to_response_or_exit_flow(current_user, previous_response, next_response, params)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity

    private

    def url_to_response_or_exit_flow(current_user, previous_response, next_response, params)
      if next_response.present? && not_a_mentor_or_filled_out_for_myself?(next_response, current_user)
        url_to_response(next_response, params)
      else
        url_to_exit_flow(current_user, previous_response)
      end
    end

    def url_to_response(response, params)
      questionnaire_path(uuid: response.uuid, **params)
    end

    def not_a_mentor_or_filled_out_for_myself?(response, current_user)
      !current_user.mentor? || response.protocol_subscription.for_myself?
    end

    def url_to_exit_flow(current_user, previous_response)
      # If there is a redirect_url on the previous response, redirect to it.
      if previous_response && previous_response.measurement.redirect_url.present?
        previous_response.measurement.redirect_url
      elsif current_user.mentor? # if we are a mentor redirect to the mentor overview page
        mentor_overview_index_path
      else # otherwise to the done route
        klaar_path
      end
    end
  end
end
