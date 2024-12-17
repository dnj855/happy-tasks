class DashboardController < ApplicationController
  before_action :set_family

  def index
    @message = "Vous avez une nouvelle tâche à vérifier"
    @user = current_user
    if current_user.child?
      if @family
        redirect_to child_dashboard_family_path(@family)
      else
        redirect_to root_path, alert: "Aucune famille trouvée."
      end
    else
    end
    @children = Child.includes(:tasks).where(family_id: @family.id)
  end

  def view
    if current_user.child? && current_user.child.present?
      @child = current_user.child
      @family = @child.family
      @children = @family.children
      @tasks_today = @child.tasks.today
      authorize @family
    else
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  private

  def set_family
    @family = current_user.family
  end

end
