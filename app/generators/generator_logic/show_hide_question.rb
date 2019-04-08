# frozen_string_literal: true

module GeneratorLogic
  class ShowHideQuestion
    class << self
      def should_show?(question, response_id)
        return true unless question.key?(:show_after)

        show_after_hash = ensure_show_after_hash(question[:show_after])

        return deal_with_type(show_after_hash, response_id) if show_after_hash.key?(:type)

        deal_with_dates(show_after_hash, response_id)
      end

      private

      def deal_with_dates(show_after_hash, response_id)
        if show_after_hash.key?(:offset)
          show_after_hash[:date] = convert_offset_to_date(show_after_hash[:offset],
                                                          response_id)
        end
        ensure_date_validity(show_after_hash[:date])
        show_after = show_after_hash[:date].in_time_zone
        show_after < Time.zone.now
      end

      def deal_with_type(show_after_hash, response_id)
        Response.find_by_id(response_id).last? if show_after_hash[:type] == :only_on_final_questionnaire
      end

      def ensure_show_after_hash(show_after)
        return { type: :only_on_final_questionnaire } if only_final?(show_after)
        return { offset: show_after } if an_offset?(show_after)
        return { date: show_after } if a_time?(show_after)

        raise "Unknown show_after type: #{show_after}"
      end

      def ensure_date_validity(date)
        raise "Unknown show_after date type: #{date}" unless a_time?(date)
      end

      def convert_offset_to_date(offset, response_id)
        raise "Unknown show_after offset type: #{offset}" unless an_offset?(offset)

        response = Response.find_by_id(response_id)
        return 2.seconds.ago if response.blank? # If we don't have a response, just show it

        TimeTools.increase_by_duration(response.protocol_subscription.start_date, offset)
      end

      def only_final?(show_after)
        show_after == :finalizing_study
      end

      def a_time?(value)
        TimeTools.a_time?(value)
      end

      def an_offset?(value)
        TimeTools.an_offset?(value)
      end
    end
  end
end
