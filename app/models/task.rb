class Task < ApplicationRecord
  belongs_to :child
  belongs_to :task_type
end
