# frozen_string_literal: true

class Role < ApplicationRecord
  GROUPS = [Person::STUDENT, Person::MENTOR, Person::SOLO, Person::OTHER].freeze

  validates :group, inclusion: GROUPS
  validates :title, presence: true
  validates :title, uniqueness: { scope: :team_id }
  belongs_to :team
  has_many :people, dependent: :destroy

  def stats(week_number, year, threshold_percentage)
    all_person_stats = { met_threshold_completion: 0, completed: 0, total: 0 }
    people.each do |person|
      person_stats = person.stats(week_number, year, threshold_percentage)
      all_person_stats[:completed] += person_stats[:completed]
      all_person_stats[:total] += person_stats[:total]
      all_person_stats[:met_threshold_completion] += person_stats[:met_threshold_completion]
    end
    all_person_stats
  end
end
