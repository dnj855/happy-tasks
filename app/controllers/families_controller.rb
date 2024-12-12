class FamiliesController < ApplicationController

  def new
    @family = Family.new
    authorize @family
  end

  def create
    @family = Family.new(family_params)
    authorize @family

    if @family.save
      redirect_to root_path, notice: 'Votre famille a été créée.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def family_params
    params.require(:family).permit(:name)
  end
end
