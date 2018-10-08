class AllowNullForMobilePhone < ActiveRecord::Migration[5.0]
  def change
    change_column_null :people, :mobile_phone, true
  end
end
