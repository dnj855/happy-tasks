class TaskType < ApplicationRecord
  has_many :tasks

  validates_inclusion_of :name, :in => %w( Animaux Apprentissage Chambre Cuisine Hygiène Linge Ménage )
end
