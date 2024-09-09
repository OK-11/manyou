class TasksController < ApplicationController
  before_action :set_task , only: [:show, :edit, :update, :destroy]
  def index
    if params[:search].present?
      status = params[:search][:status]
      title = params[:search][:title]

      if status.present? && title.present?
        @tasks = Task.search_status(status).search_title(title).order(created_at: :desc).page(params[:page]).per(10)
      elsif status.present?
        @tasks = Task.search_status(status).order(created_at: :desc).page(params[:page]).per(10)
      elsif title.present?
        @tasks = Task.search_title(title).order(created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
      end
      
    elsif params[:sort_deadline_on].present?
      if params[:sort_deadline_on] == "true"
        @tasks = Task.order(:deadline_on).page(params[:page]).per(10)
      else
        @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
      end

    elsif params[:sort_priority].present?
      if params[:sort_priority] == "true"
        @tasks = Task.order(priority: :desc).page(params[:page]).per(10)
      else
        @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
      end
      
    else
      @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
    end
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end

