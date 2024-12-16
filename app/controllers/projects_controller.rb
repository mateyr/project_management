# frozen_string_literal: true

# ProjectsController
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  authorize_resource

  def index
    @projects = current_user.involved_projects.ordered
  end

  def show; end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      @project.collaborators.create(user: current_user, role: :admin)
      respond_to do |format|
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.turbo_stream { flash.now[:notice] = "Project was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      respond_to do |format|
        format.html { redirect_to projects_path, notice: "Project was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Project was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Project was successfully destroyed." }
    end
  end

  private

  def set_project
    @project = current_user.involved_projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
