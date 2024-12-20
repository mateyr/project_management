# frozen_string_literal: true

class CollaboratorsController < ApplicationController
  before_action :set_project
  authorize_resource :project
  load_and_authorize_resource :collaborator, through: :project

  def index
    @collaborators = @project.collaborators.includes(:user)
  end

  def new
    @collaborator = @project.collaborators.build
  end

  def create
    @collaborator = @project.collaborators.build(collaborator_params)

    if @collaborator.save
      respond_to do |format|
        format.html { redirect_to project_collaborators_path(@project), notice: "Collaborador was successfully added." }
        format.turbo_stream { flash.now[:notice] = "Collaborador was successfully added." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @collaborator.destroy

    respond_to do |format|
      format.html do
        redirect_to project_collaborators_path(@project), notice: "Collaborador was successfully destroyed."
      end
      format.turbo_stream { flash.now[:notice] = "Collaborador was successfully destroyed." }
    end
  end

  private

  def set_project
    @project = current_user.involved_projects.find(params[:project_id])
  end

  def collaborator_params
    params.require(:collaborator).permit(:user_id)
  end
end
