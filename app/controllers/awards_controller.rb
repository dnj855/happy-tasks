class AwardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_award, only: [:edit, :update, :destroy]

  def new
    @award = Award.new
    @children = current_user.family.children

    if params[:child_id]
      @award.child_id = current_user.family.children.find_by(id: params[:child_id])
    end
  end

  def create
    @award = Award.new(award_params)

    if @award.save
      redirect_to family_dashboard_path, notice: 'Le privilège a bien été créé.'
    else
      @children = current_user.family.children
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_award
    @award = Award.find(params[:id])
    authorize_award
  end

  def award_params
    params.require(:award).permit(:name, :value, :child_id)
  end

  def authorize_award
    unless current_user.family == @award.child.family
      redirect_to family_dashboard_path, alert: 'Vous ne pouvez pas modifier ce privilège.'
    end
  end

end
