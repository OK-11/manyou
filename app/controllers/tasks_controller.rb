class TasksController < ApplicationController
  before_action :set_task , only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = t("flash.actions.create.notice", default: "Task was successfully created.")      
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = t("flash.actions.update.notice", default: "Task was successfully updated.")
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = t("flash.actions.destroy.notice", default: "Task was successfully destroyed.")
      redirect_to tasks_path
    else
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

