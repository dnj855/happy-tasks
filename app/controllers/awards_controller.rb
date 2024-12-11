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
  end

  def destroy
  end

  private

  def set_award
    @award = Award.find(params[:id])
  end

end
