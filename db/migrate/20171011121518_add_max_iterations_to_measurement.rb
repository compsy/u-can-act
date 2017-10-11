class AddMaxIterationsToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :max_iterations, :integer, null: true
  end
end
