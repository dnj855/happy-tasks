class Award < ApplicationRecord
  belongs_to :child

  validates :name, presence: true
  validates :value, presence: true, numericality: { only_numeric: true, greater_than: 0 }
  validates_inclusion_of :periodicity, :in => %w( Quotidien Hebdomadaire Mensuel )

  def points_method_for_periodicity
    case periodicity
    when 'Quotidien'
      'day_points'
    when 'Hebdomadaire'
      'week_points'
    when 'Mensuel'
      'month_points'
    end
  end

  def given?
    given == true
  end
end
