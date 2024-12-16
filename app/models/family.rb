class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :children, dependent: :destroy
  has_many :tasks, through: :children
  accepts_nested_attributes_for :children,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :name, presence: true

end
