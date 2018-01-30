class SuperOrganization < ApplicationRecord
  belongs_to :sub,  class_name: :Organization, foreign_key: :sub_id
  belongs_to :super,  class_name: :Organization, foreign_key: :super_id
end
