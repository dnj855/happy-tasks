class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :value
      t.date :done_date
      t.date :due_date
      t.boolean :done
      t.boolean :validated
      t.string :recurrence
      t.references :child, null: false, foreign_key: true
      t.references :task_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
