# frozen_string_literal: true

class AddExternalIdentifierToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :external_identifier, :string

    # Call the initializer for each of the person objects, which causes the external_identifier
    # to be initialized (which needs to be saved)
    Person.find_each { |person| person.save! }

    change_column_null :people, :external_identifier, false
  end
end
