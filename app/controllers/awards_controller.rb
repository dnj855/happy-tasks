class AwardsController < ApplicationController

  def index
    @children = policy_scope(Child)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    @award = Award.find(params[:id])
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
  end

  private

  def set_award
    @award = Award.find(params[:id])
  end

  def award_params
    params.require(:award).permit(:given)
  end

end
