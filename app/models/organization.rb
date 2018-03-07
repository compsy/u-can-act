class Organization < ApplicationRecord
  has_many :teams, dependent: :destroy
end
