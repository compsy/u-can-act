# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :my_roles, foreign_key: 'organization_id', class_name: "Role"

	has_many :sub_super_organizations, foreign_key: :super_id, class_name: "SuperOrganization"
  has_many :sub_organizations, through: :sub_super_organizations, source: :sub

	has_many :super_sub_organizations, foreign_key: :sub_id, class_name: "SuperOrganization"
  has_many :super_organizations, through: :super_sub_organizations, source: :super

  DEFAULT_PERCENTAGE = 70

  def self.overview(week_number = nil, year = nil, threshold_percentage = nil)
    Organization.all.map do |organization|
      organization_stats = organization.stats_for_organization(week_number, year, threshold_percentage)
      { name: organization.name, data: organization_stats }
    end
  end

  def stats_for_organization(week_number, year, threshold_percentage)
    all_role_stats = Hash.new({})
    roles.each do |role|
      new_stats_for_role = stats_for_role(role, week_number, year, threshold_percentage)
      merged = all_role_stats[role.group].merge(new_stats_for_role) do |_key, val1, val2|
        val1 + val2
      end
      all_role_stats[role.group] = merged
    end
    all_role_stats
  end

  def roles
    return my_roles if sub_organizations.blank? 
    sub_organizations.map{|x| x.roles}.flatten
  end

  private

  def stats_for_role(role, week_number, year, threshold_percentage)
    role.people.each_with_object(Hash.new(0)) do |person, all_person_stats|
      person_stats = stats_for_person(person, week_number, year, threshold_percentage)
      all_person_stats[:completed] += person_stats[:completed]
      all_person_stats[:total]     += person_stats[:total]
      all_person_stats[:met_threshold_completion] += person_stats[:met_threshold_completion]
    end
  end

  def stats_for_person(person, week_number, year, threshold_percentage)
    person.protocol_subscriptions.each_with_object(Hash.new(0)) do |subscription, all_subscriptions|
      past_week = subscription.responses.in_week(week_number: week_number, year: year)
      all_subscriptions[:completed] += past_week.completed.count || 0
      all_subscriptions[:total] += past_week.count || 0
      all_subscriptions[:met_threshold_completion] += check_threshold(past_week, threshold_percentage)
    end
  end

  def check_threshold(responses, threshold_percentage)
    return 0 unless responses.count.positive?
    threshold_percentage ||= DEFAULT_PERCENTAGE
    threshold_percentage = threshold_percentage.to_i
    actual_percentage = responses.completed.count.to_d / responses.count.to_d * 100
    actual_percentage >= threshold_percentage ? 1 : 0
  end
end
