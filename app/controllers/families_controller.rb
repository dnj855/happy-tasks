class FamiliesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_family, only: [:new_children, :create_children]
  layout "enrollment"

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)

    if @family.save
      redirect_to add_children_family_path(@family.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new_children
    @family.children.build
  end

  def create_children
    children_data = params[:family][:children_attributes].values.map do |child|
      child_instance = Child.create!(
        first_name: child[:first_name],
        age: child[:age],
        family_id: @family.id
      )
      {
        id: child_instance.id,
        first_name: child[:first_name],
        age: child[:age],
        neuroatypical: child[:neuroatypical] == "1",
        neuroatypical_type: child[:neuroatypical] == "1" ? child[:neuroatypical_type] : nil,
        autonomy_level: child[:autonomy_level].to_i
      }
    end
    session[:pending_children_data] = children_data
    children_data.each do |child|
      CreateTasksJob.perform_later(child)
    end
  end

  private

  def family_params
    params.require(:family).permit(
      :name,
      children_attributes: [
        :first_name,
        :age,
        :neuroatypical,
        :neuroatypical_type,
        :autonomy_level
      ])
  end

  def set_family
    @family = Family.find(params[:id])
  end
end
