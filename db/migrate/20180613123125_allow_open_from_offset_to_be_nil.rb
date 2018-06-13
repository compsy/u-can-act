class AllowOpenFromOffsetToBeNil < ActiveRecord::Migration[5.0]
  def change
    change_column_null :measurements, :open_from_offset, true
  end
end
