# frozen_string_literal: true

require 'csv'

class SubscriptionExporter
  extend Exporters
  class << self
    def export(&_block)
      fields = %w[protocol_subscription_id hit_count state]
      headers = %w[subscription_id profile_id created_at updated_at start_at was_canceled last_hit personal_interest] +
        fields
      yield Exporters.format_headers(headers)
      Exporters.silence_logger do
        Subscription.find_each do |subscription|
          next if subscription.profile.user and TEST_EMAIL_ADDRESSES.include?(subscription.profile.user.email.downcase)
          vals = header_properties(subscription)
          fields.each do |field|
            vals[field] = subscription.send(field.to_sym)
          end
          yield Exporters.format_hash(headers, vals)
        end
      end
    end

    def export_lines
      Enumerator.new do |enum|
        Exporters::SubscriptionExporter.export do |line|
          enum << line + "\n"
        end
      end
    end

    def header_properties(subscription)
      vals = {}
      vals['subscription_id'] = subscription.id
      vals['profile_id'] = Hashers::Md5Hasher.calculate_hash(subscription.profile.id)
      vals['created_at'] = subscription.created_at.andand.strftime('%d-%m-%Y %H:%M:%S')
      vals['updated_at'] = subscription.updated_at.andand.strftime('%d-%m-%Y %H:%M:%S')
      vals['start_at'] = subscription.start_at.andand.strftime('%d-%m-%Y %H:%M:%S')
      vals['was_canceled'] = !subscription.currently_running?.to_s
      vals['last_hit'] = subscription.last_hit.andand.strftime('%d-%m-%Y %H:%M:%S')
      vals['personal_interest'] = subscription.personal_interest.andand.title
      vals
    end
  end
end
