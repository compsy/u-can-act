# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy

  def self.organization_overview(week_number = nil, year = nil)
    Organization.all.map do |organization|
      organization_stats = organization.stats_for_organization(week_number, year)
      { name: organization.name, data: organization_stats }
    end
  end

  def stats_for_organization(week_number, year)
    roles.each_with_object(Hash.new(0)) do |role, all_role_stats|
      all_role_stats[role.group] = stats_for_role(role, week_number, year)
    end
  end

  private

  def stats_for_role(role, week_number, year)
    role.people.each_with_object(Hash.new(0)) do |person, all_person_stats|
      person_stats = stats_for_person(person, week_number, year)
      all_person_stats[:completed] += person_stats[:completed]
      all_person_stats[:total]     += person_stats[:total]
    end
  end

  def stats_for_person(person, week_number, year)
    person.protocol_subscriptions.each_with_object(Hash.new(0)) do |subscription, all_subscriptions|
      past_week = subscription.responses.in_week(week_number: week_number, year: year)
      all_subscriptions[:completed] += past_week.completed.count || 0
      all_subscriptions[:total] += past_week.count || 0
    end
  end
end
