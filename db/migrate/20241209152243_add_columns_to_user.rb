class AddColumnsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :child, :boolean
    add_reference :users, :family, null: false, foreign_key: true
    add_reference :users, :child, null: true, foreign_key: true
  end
end
