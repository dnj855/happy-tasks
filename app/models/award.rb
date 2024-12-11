class Award < ApplicationRecord
  belongs_to :child

  validates :name, presence: true
  validates :value, presence: true, numericality: { only_numeric: true, greater_than: 0 }
  validates_inclusion_of :periodicity, :in => %w( quotidien hebdomadaire mensuel )

def points_method_for_periodicity
  case periodicity
  when 'quotidien'
    'day_points'
  when 'hebdomadaire'
    'week_points'
  when 'mensuel'
    'month_points'
  end
end

end
