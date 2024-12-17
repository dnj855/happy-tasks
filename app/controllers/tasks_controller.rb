class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[edit update destroy validate]
  before_action :set_children, only: %i[new create]

  def family_tasks
    @family = current_user.family
    @tasks = @family.tasks

    authorize @family, :view? if current_user.child?

    respond_to do |format|
      format.html
    end
  end

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

    if current_user.child? && @task.child == current_user.child
      if @task.update(done: params[:completed])
        NewCommentNotifier.with(record: @comment).deliver_later(@user)
        render json: { message: 'Tâche faite', completed: @task.done }
      else
        render json: { error: 'Erreur lors de la mise à jour de la tâche' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Accès interdit' }, status: :forbidden
    end
  end

  def validate
    authorize @task
    @task.update(validated: true)
    @child = @task.child
    # j'ai forcé 3 en float sinon on arrondit pas au supérieur
    points = (@task.value / 3.0).ceil
    @child.update(
      day_points: @child.day_points + points,
      week_points: @child.week_points + points,
      month_points: @child.month_points + points
    )

    respond_to do |format|
      format.turbo_stream
      # format.turbo_stream do
      #   # puts "Est ce que turbo stream rendu pour la tâche #{@task.id} ou pas non didiou"
      #   render turbo_stream: turbo_stream.replace(
      #     @task,
      #     partial: "tasks/task",
      #     locals: { task: @task }
      #   )
      # end
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
