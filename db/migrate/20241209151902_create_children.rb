class CreateChildren < ActiveRecord::Migration[7.1]
  def change
    create_table :children do |t|
      t.string :first_name
      t.integer :age
      t.integer :day_points
      t.integer :week_points
      t.integer :month_points
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
