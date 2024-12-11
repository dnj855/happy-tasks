class ModifyColumnNameTypeToPeriodicityToAwards < ActiveRecord::Migration[7.1]
  def change
    rename_column :awards, :type, :periodicity
  end
end
