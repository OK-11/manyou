class TasksController < ApplicationController
  before_action :set_task , only: [:show, :edit, :update, :destroy]
  before_action :check_mytask , only: [:show, :edit, :update, :destroy]
  def index
    @user = User.find(session[:user_id])
    @labels = @user.labels.map do |label|
      label.id
    end

    if params[:search].present?
      status = params[:search][:status]
      title = params[:search][:title]
      label = params[:search][:label].to_i

      if status.present? && title.present?

        if label.present?
          @tasks = @user.tasks.joins(:labels).where(labels: {id: label}).search_status(status).search_title(title).order(created_at: :desc).page(params[:page]).per(10)
        else
          @tasks = @user.tasks.search_status(status).search_title(title).order(created_at: :desc).page(params[:page]).per(10)
        end
        
      elsif status.present?

        if label.present?
          @tasks = @user.tasks.joins(:labels).where(labels: {id: label}).search_status(status).order(created_at: :desc).page(params[:page]).per(10)
        else
          @tasks = @user.tasks.search_status(status).order(created_at: :desc).page(params[:page]).per(10)
        end

      elsif title.present?

        if label.present?
          @tasks = @user.tasks.joins(:labels).where(labels: {id: label}).search_title(title).order(created_at: :desc).page(params[:page]).per(10)
        else
          @tasks = @user.tasks.search_title(title).order(created_at: :desc).page(params[:page]).per(10)
        end

      elsif label.present?
        @tasks = @user.tasks.joins(:labels).where(labels: {id: label}).order(created_at: :desc).page(params[:page]).per(10)
        
      else
        @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
      end
      
    elsif params[:sort_deadline_on].present?
      if params[:sort_deadline_on] == "true"
        @tasks = @user.tasks.order(:deadline_on, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
      end

    elsif params[:sort_priority].present?
      if params[:sort_priority] == "true"
        @tasks = @user.tasks.order(priority: :desc, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
      end
      
    else
      @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def new
    @user = User.find(session[:user_id])
    @task = @user.tasks.build
    @labels = @user.labels
  end

  def create
    @user = User.find(session[:user_id])
    @task = @user.tasks.build(task_params)
    if @task.save

      if params[:task][:label_ids].present?
        labels = params[:task][:label_ids]
        labels.each do |label_id|
          @task.labels << Label.find(label_id)
        end
      end

      flash[:notice] = t("flash.actions.create.notice", default: "Task was successfully created.")      
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    @labels = @task.labels
  end

  def edit
    @labels = @user.labels
  end

  def update
    if @task.update(task_params)

      @task.labels.destroy_all

      if params[:task][:label_ids].present?
        labels = params[:task][:label_ids]
        labels.each do |label_id|
          @task.labels << Label.find(label_id)
        end
      end

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
    @user = User.find(session[:user_id])
    @task = @user.tasks.find_by(id: params[:id])
  end

  def check_mytask
    unless set_task
      flash[:alert] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end


end

