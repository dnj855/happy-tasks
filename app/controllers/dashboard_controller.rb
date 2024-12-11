class DashboardController < ApplicationController
  before_action :set_family

  def index
  end

  def view
  end

  private

  def set_family
    @family = current_user.family
  end

end
