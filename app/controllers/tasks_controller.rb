class TasksController < ApplicationController
  before_action :set_task , only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task was successfully created."
      redirect_to tasks_path
    else
      flash[:alert] = "失敗"
      redirect_to new_task_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "Task was successfully updated."
      redirect_to tasks_path
    else
      flash[:alert] = "失敗"
      redirect_to edit_task_path
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = "Task was successfully destroyed."
      redirect_to tasks_path
    else
      flash[:alert] = "失敗"
      redirect_to tasks_path
    end
  end




  private

  def task_params
    params.require(:task).permit(:title, :content)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end

