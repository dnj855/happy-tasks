class Task < ApplicationRecord
  belongs_to :child
  belongs_to :task_type

  validates :name, presence: { message: "La tâche doit avoir un nom." }
  validates :task_type_id, presence: { message: "Vous devez sélectionner une catégorie." }
  validates :child_id, presence: { message: "Vous devez choisir un enfant." }

  before_validation { self.value = value.to_i }
  validates :value, presence: true, numericality: { only_numeric: true }
end
