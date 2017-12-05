# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy

  def self.generate_overview
    Organization.all.map do |org| 
      res = org.roles.reduce(Hash.new(0)) do |all_roles, role|
        res_for_role = role.people.reduce(Hash.new(0)) do |tot_for_role, person|
          cur = person.protocol_subscriptions.reduce(Hash.new(0)) do |all_subs, sub|
            past_week = sub.responses.in_week
            all_subs[:completed] += past_week.completed.count 
            all_subs[:total] += past_week.count
            all_subs
          end
          tot_for_role[:completed] += cur[:completed]
          tot_for_role[:total]     += cur[:total]
          tot_for_role
        end
        all_roles[role.group] = res_for_role
        all_roles
      end
      {name: org.name, data: res}
    end
  end
end
