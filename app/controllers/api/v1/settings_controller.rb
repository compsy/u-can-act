# frozen_string_literal: true

module Api
  module V1
    class SettingsController < ApiController
      def index
        render json: settings_to_hash(Rails.application.config.settings)
      end

      private

      def settings_to_hash(settings)
        # Converts the openstruct object
        deep_clean(JSON.parse(settings.to_json))
      end

      def deep_clean(settings)
        cur = settings['table']
        cur.delete 'modifiable'
        res = {}
        cur.each do |k, v|
          # Deep clean the hashes
          v = deep_clean(v) if v.is_a? Hash
          res[k] = v
        end
        res
      end
    end
  end
end
