class TaskType < ApplicationRecord
  has_many :tasks

  validates_inclusion_of :name, :in => %w( chambre linge ménage cuisine animaux apprentissage )
end
