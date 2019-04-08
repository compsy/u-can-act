# frozen_string_literal: true

module QuestionnaireExpanders
  class FirstAndLastExpander
    class << self
      def expand!(content, response)
        %i[title content].each do |key|
          # Just quit searching if we do not have any more tags to replace.
          break unless needs_expansion? content
          next unless content[key].is_a? Hash

          next if process_final_value(key, content, response)
          next if process_first_value(key, content, response)
          next if process_normal_value(key, content, response)
        end
        QuestionnaireExpander.expand_content(content, response)
      end

      def needs_expansion?(content)
        content[:title].is_a?(Hash) || content[:content].is_a?(Hash)
      end

      private

      def process_final_value(key, content, response)
        final_value = content[key][:last]
        return false unless response.last? && final_value.present?

        content[key] = final_value
        true
      end

      def process_first_value(key, content, response)
        initial_value = content[key][:first]
        previous = PreviousResponseFinder.find(response)
        return false unless previous.blank? && initial_value.present?

        content[key] = initial_value
        true
      end

      def process_normal_value(key, content, _response)
        content[key] = content[key][:normal]
        true
      end
    end
  end
end
