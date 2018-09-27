# frozen_string_literal: true

class IbanValidator < ActiveModel::Validator
  def validate(record)
    return if record.iban.nil? || IBANTools::IBAN.valid?(record.iban)

    record.errors.add :iban, record.errors.generate_message(:iban, :invalid)
  end
end
