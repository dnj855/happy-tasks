class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[edit update destroy validate]
  before_action :set_children, only: %i[new create]

  def index
    @family = current_user.family
    @tasks = policy_scope(@family.tasks)
   end

  def new
    @task = Task.new
    @child = Child.find(params[:child_id])

    authorize @task
  end

  def create
    @task = Task.new(task_params)
    @child = Child.find(task_params[:child_id])
    authorize @task

    if @task.save
      redirect_to family_dashboard_path, notice: 'Tâche créée'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task
    @task.update(task_params)
    redirect_to family_dashboard_path, notice: 'Tâche modifiée'
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to tasks_path, notice: 'Tâche supprimée'
  end

  def declare_done
    @task = Task.find(params[:id])
    authorize @task

    if @task.update(completed: params[:completed])
      render json: { message: 'Task updated successfully' }
    else
      render json: { error: 'Failed to update task' }, status: :unprocessable_entity
    end
  end

  def validate
    authorize @task
    @task.update(validated: true)
    @child = @task.child
    points = (@task.value / 3.0).ceil
    @child.update(
      day_points: @child.day_points + points,
      week_points: @child.week_points + points,
      month_points: @child.month_points + points
    )

    respond_to do |format|
      format.turbo_stream
      format.json do
        render json: {
          points: {
            day_points: child.day_points,
            week_points: child.week_points,
            month_points: child.month_points
          }
        }
      end
    end
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
