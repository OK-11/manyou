class LabelsController < ApplicationController

  before_action :check_mylabel , only: [:edit, :update, :destroy]
  def index
    @user = User.find(session[:user_id])
    @labels = @user.labels
  end

  def new
    @user = User.find(session[:user_id])
    @label = @user.labels.build
  end

  def create
    @user = User.find(session[:user_id])
    @label = @user.labels.build(label_params)
    if @label.save
      flash[:notice] = "ラベルを登録しました"      
      redirect_to labels_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(session[:user_id])
    @label = @user.labels.find(params[:id])
  end

  def update
    @user = User.find(session[:user_id])
    @label = @user.labels.find(params[:id])
    if @label.update(label_params)
      flash[:notice] = "ラベルを更新しました"
      redirect_to labels_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(session[:user_id])
    @label = @user.labels.find(params[:id])
    if @label.destroy
      flash[:notice] = "ラベルを削除しました"
      redirect_to labels_path
    end
  end


  private
  def label_params
    params.require(:label).permit(:name)
  end

  def set_task
    @session_user = User.find(session[:user_id])
    @check_label = @session_user.labels.find_by(id: params[:id])
  end
  def check_mylabel
    unless set_task.present?
      flash[:alert] = "アクセス権限がありません"
      redirect_to labels_path
    end
  end
end
