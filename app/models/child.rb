class Child < ApplicationRecord
  belongs_to :family
  has_many :tasks, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_one_attached :avatar
  before_create :set_avatar

  validates :first_name, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 3 }
  #validates :day_points,  numericality: { only_numeric: true }
  #validates :week_points, numericality: { only_numeric: true }
  #validates :month_points, numericality: { only_numeric: true }
  #
  private

  def set_avatar
    avatar_path = Dir.glob(Rails.root.join("app/assets/images/default_avatars/*")).sample
    file = File.open(avatar_path)
    self.avatar.attach(io: file, filename: 'avatar.png', content_type: "image/png")
    file.close
  end
end
