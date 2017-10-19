# frozen_string_literal: true

class Role < ApplicationRecord
  validates :group, presence: true
  validates_uniqueness_of :group, scope: :organization_id
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :organization_id
  belongs_to :organization
  validates :organization_id, presence: true
end
