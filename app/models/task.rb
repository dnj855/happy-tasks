class Task < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :child
  belongs_to :task_type

  validates :name, presence: { message: "La tâche doit avoir un nom." }
  validates :task_type_id, presence: { message: "Vous devez sélectionner une catégorie." }
  validates :child_id, presence: { message: "Vous devez choisir un enfant." }

  before_validation { self.value = value.to_i }
  after_commit :bust_stats_cache
  validates :value, presence: true, numericality: { only_numeric: true }

  scope :today, -> { where("DATE(created_at) = ?", Date.today) }

  def broadcast_tasks(user)
    broadcast_replace_to "task-#{self.id}",
    target: dom_id(self),
    partial: "tasks/task",
    locals: { task: self, user: user }
  end

  private

  def task_changed?
    saved_change_to_done? || saved_change_to_validated?
  end

  def bust_stats_cache
    Rails.cache.delete_matched("monthly_stats/*")
  end

end
