# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  authorize_resource

  def index
    @projects = current_user.projects.ordered
  end

  def show; end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.project_users.create(user: current_user, role: :admin)
      respond_to do |format|
        format.html { redirect_to projects_path, notice: 'Project was sucessfully created.' }
        format.turbo_stream { flash.now[:notice] = "Project was sucessfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      respond_to do |format|
        format.html { redirect_to projects_path, notice: "Project was sucessfully updated." }
        format.turbo_stream { flash.now[:notice] = "Project was sucessfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was sucessfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Project was sucessfully destroyed." }
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
