class AddOnlyRedirectIfNothingElseReadyToMeasurement < ActiveRecord::Migration[6.1]
  def change
    add_column :measurements, :only_redirect_if_nothing_else_ready, :boolean, null: false, default: false
  end
end
