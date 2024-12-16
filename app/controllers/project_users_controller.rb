# frozen_string_literal: true

# This controller manages project_users, which are presented as "collaborators" in the views
# to make user management in projects more intuitive.
class ProjectUsersController < ApplicationController
  before_action :set_project
  authorize_resource :project
  load_and_authorize_resource :project_user, through: :project, through_association: :collaborators

  def index
    @project_users = @project.collaborators.includes(:user)
  end

  def new
    @project_user = @project.collaborators.build
  end

  def create
    @project_user = @project.collaborators.build(project_user_params)

    if @project_user.save
      respond_to do |format|
        format.html { redirect_to project_project_users_path(@project), notice: "Collaborador was sucessfully added." }
        format.turbo_stream { flash.now[:notice] = "Collaborador was sucessfully added." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @project_user.destroy

    respond_to do |format|
      format.html do
        redirect_to project_project_users_path(@project), notice: "Collaborador was sucessfully destroyed."
      end
      format.turbo_stream { flash.now[:notice] = "Collaborador was sucessfully destroyed." }
    end
  end

  private

  def set_project
    @project = current_user.involved_projects.find(params[:project_id])
  end

  def project_user_params
    params.require(:project_user).permit(:user_id)
  end
end
