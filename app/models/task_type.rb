class TaskType < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates_inclusion_of :name, :in => %w( chambre linge ménage devoirs animaux sortir )
end
