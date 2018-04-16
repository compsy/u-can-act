# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :teams, dependent: :destroy

  def self.overview(week_number: nil, year: nil, threshold_percentage: nil, bust_cache: false)
    overview = Organization.all.map do |organization|
      organization_stats = organization.teams.map do |team|
        team[:data]
      end
      { name: organization.name, data: organization_stats}
    end
    overview
  end
end
