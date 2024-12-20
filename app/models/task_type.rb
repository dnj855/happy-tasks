class TaskType < ApplicationRecord
  has_many :tasks
  after_commit :bust_cache

  validates_inclusion_of :name, :in => %w( Animaux Apprentissage Chambre Cuisine Hygiène Linge Ménage )

  private

  def bust_cache
    Rails.cache.delete('task_types')
  end
  
end
