class DashboardController < ApplicationController
  before_action :set_family

  def index
    if current_user.child?
      handle_child_user
    else
      @family = current_user.family
      
      @children = @family.children
        .includes(avatar_attachment: :blob)
      
      @todays_tasks = Task.where(
        child_id: @children.pluck(:id),
        created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      ).group_by(&:child_id)
    end
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

  def statistics
    @family = current_user.family
    children_for_stats = @family.children.select(:id)
    @task_counts = TaskStatisticsCalculator.new(children_for_stats).calculate_monthly_stats
    @children = @family.children
    
    render partial: "families/tasks_graphs", layout: false
  end

  private

  def set_family
    @family = current_user.family
  end

  def handle_child_user
    if @family
      redirect_to child_dashboard_family_path(@family)
    else
      redirect_to root_path, alert: "Aucune famille trouvée."
    end
  end

end
