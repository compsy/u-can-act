class AddRedirectUrlToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :redirect_url, :string, null: true
  end
end
