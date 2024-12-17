class FamilyTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @family = current_user.family
    children = current_user.family.children
    @tasks = policy_scope(Task).where(child_id: current_user.family.children.pluck(:id))
  end
end
