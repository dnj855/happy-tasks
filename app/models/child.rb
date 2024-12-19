class Child < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :family
  has_many :users
  has_many :tasks, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_one_attached :avatar
  before_create :set_avatar
  after_update_commit :broadcast_points, if: :points_changed?

  attr_accessor :neuroatypical, :neuroatypical_type, :autonomy_level, :tsa, :tdah, :dys, :autre

  validates :first_name, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 3 }
  validates :autonomy_level, inclusion: { in: 1..5 }, allow_nil: true
  #validates :day_points,  numericality: { only_numeric: true }
  #validates :week_points, numericality: { only_numeric: true }
  #validates :month_points, numericality: { only_numeric: true }
  #
  private

  def points_changed?
    saved_change_to_day_points? || 
    saved_change_to_week_points? || 
    saved_change_to_month_points?
  end

  def broadcast_points
    if saved_change_to_day_points?
      Rails.logger.debug "Broadcasting day points update for child #{id}"
      broadcast_replace_to "child-#{id}-day_points",
                         target: "child-#{id}-day_points",
                         partial: "children/points_update",
                         locals: { points: day_points, child: self, point_type: 'day' }
      
      # Broadcast des awards quotidiens
      awards.where(periodicity: 'Quotidien').each do |award|
        Rails.logger.debug "Broadcasting award update for award #{award.id}"
        broadcast_replace_to "child-#{id}-awards",
                           target: dom_id(award),
                           partial: "awards/award",
                           locals: { award: award, points: day_points, child: self }
      end
    end
  
    # Même chose pour les points hebdomadaires
    if saved_change_to_week_points?
      Rails.logger.debug "Broadcasting week points update for child #{id}"
      broadcast_replace_to "child-#{id}-week_points",
                         target: "child-#{id}-week_points",
                         partial: "children/points_update",
                         locals: { points: week_points, child: self, point_type: 'week' }
      
      awards.where(periodicity: 'Hebdomadaire').each do |award|
        Rails.logger.debug "Broadcasting award update for award #{award.id}"
        broadcast_replace_to "child-#{id}-awards",
                           target: dom_id(award),
                           partial: "awards/award",
                           locals: { award: award, points: week_points, child: self }
      end
    end
  
    # Et mensuels
    if saved_change_to_month_points?
      Rails.logger.debug "Broadcasting month points update for child #{id}"
      broadcast_replace_to "child-#{id}-month_points",
                         target: "child-#{id}-month_points",
                         partial: "children/points_update",
                         locals: { points: month_points, child: self, point_type: 'month' }
      
      awards.where(periodicity: 'Mensuel').each do |award|
        Rails.logger.debug "Broadcasting award update for award #{award.id}"
        broadcast_replace_to "child-#{id}-awards",
                           target: dom_id(award),
                           partial: "awards/award",
                           locals: { award: award, points: month_points, child: self }
      end
    end
  end

  def set_avatar
    avatar_path = Dir.glob(Rails.root.join("app/assets/images/default_avatars/*")).sample
    file = File.open(avatar_path)
    self.avatar.attach(io: file, filename: 'avatar.png', content_type: "image/png")
  end

end
