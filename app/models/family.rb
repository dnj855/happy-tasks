class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :children, dependent: :destroy

  validates :name, presence: true

end
