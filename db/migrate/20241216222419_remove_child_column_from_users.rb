class RemoveChildColumnFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :child, :boolean
  end
end
