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
    @family = current_user.family
    @children = @family.children
    @task_counts = @children.each_with_object({}) do |child, counts|
      counts[child.id] = TaskType.all.each_with_object({}) do |task_type, task_hash|
        # Sélectionner les tâches complétées et réalisées dans le mois courant pour le task_type,
        tasks_in_month = child.tasks
        .where(task_type_id: task_type.id, done: true)
        .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
        # puis compter le nombre de tâches réalisées dans le mois courant pour ce type
        task_hash[task_type.name] = tasks_in_month.count
      end
    end
    @children = Child.includes(:tasks).where(family_id: @family.id)
  end

  def view
    if current_user.child? && current_user.child.present?
      @child = current_user.child
      @family = @child.family
      @children = @family.children
      @tasks_today = @child.tasks.today
      ## récupération des données pour les graphs

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
