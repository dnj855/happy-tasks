class DashboardController < ApplicationController
  before_action :set_family

  def index
    @children = Child.includes(:tasks).where(family_id: @family.id)
  end

  def view
  end

  private

  def set_family
    @family = current_user.family
  end

end
