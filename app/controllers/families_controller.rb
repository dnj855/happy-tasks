class FamiliesController < ApplicationController
  skip_before_action :authenticate_user!
  layout "enrollment"

  def new
    @family = Family.new
    authorize @family
  end

  def create
    @family = Family.new(family_params)
    authorize @family

    if @family.save
      redirect_to new_children_family_path(@family.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new_children
    @family = Family.find(params[:id])
    authorize @family
    @family.children.build
  end

  private

  def family_params
    params.require(:family).permit(
      :name,
      children_attributes: [:id, :first_name, :age, :_destroy])
  end
end
