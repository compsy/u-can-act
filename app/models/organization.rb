# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :teams, dependent: :destroy
  ORGANIZATION_OVERVIEW_BASE_KEY = 'organization_overview'

  def self.overview(week_number: nil, year: nil, threshold_percentage: nil, bust_cache: false)
    key = overview_key(week_number, year)
    RedisCachedCall.cache(key, bust_cache) do
      Organization.all.map do |organization|
        organization_stats = organization.teams.map do |team|
          team.stats(week_number, year, threshold_percentage)
        end
        organization_stats = summarize_organization_data(organization_stats)
        { name: organization.name, data: organization_stats }
      end
    end
  end

  def self.overview_key(week_number = nil, year = nil)
    week_number = (week_number || Time.zone.now.to_date.cweek).to_i
    year = (year || Time.zone.now.to_date.cwyear).to_i
    "#{ORGANIZATION_OVERVIEW_BASE_KEY}_#{year}_#{week_number}"
  end

  def self.summarize_organization_data(organization_data)
    result = {}
    organization_data.each do |team|
      team.each do |person_key, value|
        result[person_key] = {} unless result.key? person_key
        result[person_key].merge!(value) { |_k, total, current| total + current }

        # Currently not supported
        result[person_key].delete :percentage_above_threshold
      end
    end
    result
  end
end
