# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy

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
      role_stats = stats_for_role(role, week_number, year, threshold_percentage)

      # Note that we merge the stats based on the group of the role, not on the title.
      merged = all_role_stats[role.group].merge(role_stats) do |_key, val1, val2|
        val1 + val2
      end
      all_role_stats[role.group] = merged
    end
    calculate_above_threshold_percentage(all_role_stats)
  end

  private

  def calculate_above_threshold_percentage(role_stats)
    role_stats.each_key do |group|
      roles_for_group = roles.where(group: group)
      perc = calculate_above_threshold_for_group(roles_for_group, role_stats[group])
      role_stats[group][:percentage_above_threshold] = perc
    end
    role_stats
  end

  def calculate_above_threshold_for_group(roles_for_group, role_stats_for_group)
    total_people = roles_for_group.reduce(0) { |tot, val| tot + val.people.count }
    total_people.positive? ? role_stats_for_group[:met_threshold_completion].to_d / total_people.to_d * 100 : 0
  end

  def stats_for_role(role, week_number, year, threshold_percentage)
    role.people.each_with_object(Hash.new(0)) do |person, all_person_stats|
      person_stats = stats_for_person(person, week_number, year, threshold_percentage)
      all_person_stats[:completed] += person_stats[:completed]
      all_person_stats[:total]     += person_stats[:total]
      all_person_stats[:met_threshold_completion] += person_stats[:met_threshold_completion]
    end
  end

  def stats_for_person(person, week_number, year, threshold_percentage)
    person_completed = 0
    person_total = 0
    person.protocol_subscriptions.each do |subscription|
      past_week = subscription.responses.in_week(week_number: week_number, year: year)
      person_completed += past_week.completed.count || 0
      person_total += past_week.count || 0
    end
    {
      met_threshold_completion: check_threshold(person_completed,
                                                person_total,
                                                threshold_percentage),
      completed: person_completed,
      total: person_total
    }
  end

  def check_threshold(completed, total, threshold_percentage)
    return 0 unless total.positive?
    threshold_percentage ||= DEFAULT_PERCENTAGE
    threshold_percentage = threshold_percentage.to_i
    actual_percentage = completed.to_d / total.to_d * 100
    actual_percentage >= threshold_percentage ? 1 : 0
  end
end
