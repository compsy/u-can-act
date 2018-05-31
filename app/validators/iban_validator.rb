class IbanValidator < ActiveModel::Validator
  def validate(record)
    unless record.iban.nil? || IBANTools::IBAN.valid?(record.iban)
      record.errors.add :iban, record.errors.generate_message(:iban, :invalid)
    end
  end
end
