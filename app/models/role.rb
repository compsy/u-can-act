# frozen_string_literal: true

class Role < ApplicationRecord
  validates :group, inclusion: [Person::STUDENT, Person::MENTOR]
  validates_uniqueness_of :group, scope: :organization_id
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :organization_id
  belongs_to :organization
  has_many :people
  validates :organization_id, presence: true
end
