class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  skip_after_action :verify_policy_scoped, if: :mission_control_controller?

  layout :layout_by_resource

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)|(^dashboard$)|(^families$)/
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def mission_control_controller?
    is_a?(::MissionControl::Jobs::QueuesController) || is_a?(::MissionControl::Jobs::JobsController)
  end
end
