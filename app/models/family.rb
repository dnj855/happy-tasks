class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :children, dependent: :destroy
  has_many :tasks, through: :children

  validates :name, presence: true

end
