class CreateAwards < ActiveRecord::Migration[7.1]
  def change
    create_table :awards do |t|
      t.string :name
      t.text :description
      t.integer :value
      t.string :type
      t.boolean :given
      t.date :date
      t.references :child, null: false, foreign_key: true

      t.timestamps
    end
  end
end
