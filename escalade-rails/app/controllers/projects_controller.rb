class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.projects
  end
end
