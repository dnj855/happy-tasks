class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy validate]
  before_action :set_children, only: %i[new create]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to family_dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task.update(task_params)
    redirect_to tasks_path
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Tâche supprimée'
  end

  def declare_done
  end

  def validate
    @task.update(validated: true)
    child = @task.child
    points = (@task.value / 3).round
    @task.child.update(
      day_points: child.day_points + points,
      week_points: child.week_points + points,
      month_points: child.month_points + points
    )
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :value, :task_type_id, :child_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_children
    @children = current_user.family.children
  end
end
