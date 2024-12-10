class ModifyDefaultDoneAndValidateToTasks < ActiveRecord::Migration[7.1]
  def change
    change_column(:tasks, :done, :boolean, default: false)
    change_column(:tasks, :validated, :boolean, default: false)
  end
end
