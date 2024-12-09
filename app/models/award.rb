class Award < ApplicationRecord
  belongs_to :child

validates :name, presence: true
validates :value, presence: true, numericality: { only_numeric: true, greater_than: 0 }

validates_inclusion_of :type, :in => %w( journalier hebdomadaire mensuel )

end
