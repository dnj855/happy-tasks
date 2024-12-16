class DashboardController < ApplicationController
  before_action :set_family

  def index
    if current_user.child?
      if @family
        redirect_to child_dashboard_family_path(@family)
      else
        redirect_to root_path, alert: "Aucune famille trouvée."
      end
    else
    end
  end

  def view
    if current_user.child? && current_user.child.present?
      @child = current_user.child
      @family = @child.family
    else
      @family = current_user.family
    end
  end

  private

  def set_family
    @family = current_user.family
  end

end
