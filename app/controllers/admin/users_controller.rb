class Admin::UsersController < ApplicationController

  before_action :admin_required

  def index
    @users = User.includes(:tasks).all
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] =  "ユーザを登録しました"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      flash[:notice] = "ユーザを更新しました"
      redirect_to admin_users_path
    else
      flash[:alert] = "管理者が0人になるため権限を変更できません"
      render :edit
    end
  
  end
    

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
     
      flash[:notice] = "ユーザを削除しました"
      redirect_to admin_users_path
      
    else
      flash[:alert] = "管理者が0人になるため削除できません"
      @users = User.includes(:tasks).all
      render :index
    end
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def admin_required
    @user = User.find(session[:user_id])
    unless @user.admin == true
      flash[:alert] = "管理者以外アクセスできません"
      redirect_to tasks_path
    end
  end
end
