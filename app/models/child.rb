class Child < ApplicationRecord
  belongs_to :family
  has_many :tasks
  has_many :awards
end
