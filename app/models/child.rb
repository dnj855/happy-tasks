class Child < ApplicationRecord
  belongs_to :family
  has_many :tasks, dependent: :destroy
  has_many :awards, dependent: :destroy

  validates :first_name, presence: true
  validates :age, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 3 }
  validates :day_points,  numericality: { only_numeric: true }
  validates :week_points, numericality: { only_numeric: true }
  validates :month_points, numericality: { only_numeric: true }

end
