class ChildrenController < ApplicationController
  def new
    @child = Child.new
    authorize @child
  end

  def create
    @child = Child.new(child_params)
    @child.family = current_user.family
    authorize @child

    if @child.save
      redirect_to family_dashboard_path(@child.family), notice: 'Votre enfant a été enregistré .'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def child_params
    params.require(:child).permit(:first_name, :age)
  end
end
