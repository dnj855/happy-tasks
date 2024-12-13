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
    @award.value = award_params['value'].to_i
    @child = Child.find(award_params[:child_id])
    authorize @award

    if @award.save
      redirect_to awards_path, notice: 'Privilège créé'
    else
      @children = current_user.family.children
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @award = Award.find(params[:id])
    @children = current_user.family.children
    @child = @award.child
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
        render :edit, status: :unprocessable_entity
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
    params.require(:award).permit(:name, :value, :child_id, :given, :periodicity)
  end

end
