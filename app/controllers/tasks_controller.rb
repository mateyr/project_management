# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  authorize_resource :project
  load_and_authorize_resource :task, through: :project

  def show; end

  def new
    @task = @project.tasks.build
  end

  def edit; end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: "Task was sucessfully created." }
        format.turbo_stream { flash.now[:notice] = "Task was sucessfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: "Task was sucessfully updated." }
        format.turbo_stream { flash.now[:notice] = "Task was sucessfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to projects_path(@project), notice: "Task was sucessfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Task was sucessfully destroyed." }
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def task_params
    params.required(:task).permit(:name, :description, :end_date, :status, :user_id)
  end
end
