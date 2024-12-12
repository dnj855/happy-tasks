class AwardsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_award, only: [:edit, :update, :destroy]


  def index
  @children = policy_scope(Child)
  end

  def new
    @award = Award.new
    @children = current_user.family.children
    @child = Child.find(params[:child_id])

    authorize @award

    # if params[:child_id]
    #   @award.child_id = current_user.family.children.find_by(id: params[:child_id])
    # end
  end

  def create
    @award = Award.new(award_params)

    authorize @award

    if @award.save
      redirect_to family_dashboard_path, notice: 'Le privilège a bien été créé.'
    else
      @children = current_user.family.children
      render :new
    end
  end

  def edit
    authorize @award
  end

  def update
    @child = @award.child
    points_method = @award.points_method_for_periodicity

    authorize @award
    
    ActiveRecord::Base.transaction do
      if @award.update(award_params)
        @child.update!(points_method => @child.send(points_method) - @award.value)
        
        respond_to do |format|
          format.turbo_stream
        end
      else
        render status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize @award
  end

  private

  def set_award
    @award = Award.find(params[:id])
  end

  def award_params
    params.require(:award).permit(:name, :value, :child_id, :given)
  end

end
