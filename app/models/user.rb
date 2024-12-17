class User < ApplicationRecord
  # has_many :children
  belongs_to :family
  belongs_to :child, optional: true
  has_many :notifications, class_name: 'Noticed::Notification', as: :recipient

  validates :first_name, presence: true

  def child?
    self.child.present?
  end

  def parent?
    !self.child?
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
