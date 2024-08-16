# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]

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

  def update; end

  def destroy; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.required(:task).permit(:name, :description, :end_date, :status, :user_id)
  end
end
