# frozen_string_literal: true

FactoryBot.define do
  factory :invitation_set do
    person
    invitation_text 'Vul nu de volgende vragenlijst in '
  end
end
