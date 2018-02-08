# frozen_string_literal: true

class AddExternalIdentifierToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :external_identifier, :string

    Person.all.each do |person|
      next if person.external_identifier
      person.external_identifier = RandomAlphaNumericStringGenerator.generate(Person::IDENTIFIER_LENGTH)
      while Person.where(external_identifier: person.external_identifier).count.positive?
        person.external_identifier = RandomAlphaNumericStringGenerator.generate(Person::IDENTIFIER_LENGTH)
      end
      person.save!
    end

    change_column_null :people, :external_identifier, false
  end
end
