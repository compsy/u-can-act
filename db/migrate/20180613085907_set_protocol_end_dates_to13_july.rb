# frozen_string_literal: true

class SetProtocolEndDatesTo13July < ActiveRecord::Migration[5.0]
  def change
    # => Fri, 13 Jul 2018 00:00:00 CEST +02:00
    date = Time.find_zone('Amsterdam').local(2018, 7, 13, 0, 0)
    ProtocolSubscription.active.find_each do |pr|
      pr.update_attributes!(end_date: date)
    end
  end
end
