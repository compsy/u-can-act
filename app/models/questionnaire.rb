# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
  validates :key, presence: true, uniqueness: true, format: { with: /\A[a-z]+[a-z_0-9]*\Z/ }
  serialize :content, Array
  validate :all_content_ids_unique
  has_many :measurements, dependent: :destroy
  has_many :informed_consent_protocols, class_name: 'Protocol', dependent: :nullify,
                                        foreign_key: 'informed_consent_questionnaire_id'

  scope :pilot, (lambda {
    where('name = :name1 OR name = :name2 OR name = :name3 OR name = :name4 OR ' \
          'name = :name5 OR name = :name6 OR name = :name7 OR name = :name8 OR ' \
          'name = :name9 OR name = :name10 OR name = :name11 OR name = :name12 OR ' \
          'name = :name13 OR name = :name14 OR name = :name15',
          name1: 'dagboek mentoren 1x per week donderdag',
          name2: 'nameting mentoren 1x per week',
          name3: 'informed consent mentoren 1x per week',
          name4: 'dagboek studenten 1x per week donderdag',
          name5: 'nameting studenten 1x per week',
          name6: 'dagboek studenten 2x per week maandag',
          name7: 'nameting studenten 2x per week',
          name8: 'dagboek studenten 5x per week maandag',
          name9: 'nameting studenten 5x per week',
          name10: 'informed consent studenten 1x per week',
          name11: 'informed consent studenten 2x per week',
          name12: 'informed consent studenten 5x per week',
          name13: 'dagboek studenten 2x per week donderdag',
          name14: 'dagboek studenten 5x per week dinsdag, woensdag, vrijdag',
          name15: 'dagboek studenten 5x per week donderdag')
  })

  def all_content_ids_unique
    ids = content.map { |entry| entry[:id] }
    result = ids.detect { |entry| ids.count(entry) > 1 }

    return if result.blank?

    errors.add(:content, 'can only have a series of unique ids')
  end
end
