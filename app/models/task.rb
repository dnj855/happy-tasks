class Task < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :child
  belongs_to :task_type

  validates :name, presence: { message: "La tâche doit avoir un nom." }
  validates :task_type_id, presence: { message: "Vous devez sélectionner une catégorie." }
  validates :child_id, presence: { message: "Vous devez choisir un enfant." }

  before_validation { self.value = value.to_i }
  validates :value, presence: true, numericality: { only_numeric: true }

  scope :today, -> { where("DATE(created_at) = ?", Date.today) }

  def broadcast_tasks
    # Broadcast pour les parents
    broadcast_replace_to "task-parent-#{self.id}",
      target: dom_id(self),
      partial: "tasks/task",
      locals: { task: self, role: "parent" }
      
    # Broadcast pour les enfants
    broadcast_replace_to "task-child-#{self.id}",
      target: dom_id(self),
      partial: "tasks/task",
      locals: { task: self, role: "child" }
  end

  private

end
