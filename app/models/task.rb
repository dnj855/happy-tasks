class Task < ApplicationRecord
  belongs_to :child
  belongs_to :task_type

  validates :name, presence: true

  before_validation { self.value = value.to_i }
  validates :value, presence: true, numericality: { only_numeric: true }
end
