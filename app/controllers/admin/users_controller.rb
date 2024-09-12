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
    if params[:user][:admin] == false
      if @user.admin_user_cannot_update
        render :edit
      else
        if @user.update(user_params)
          flash[:notice] = "ユーザを更新しました"
          redirect_to admin_users_path
        else
          render :edit
        end
      end
    else
      if @user.update(user_params)
        flash[:notice] = "ユーザを更新しました"
        redirect_to admin_users_path
      else
        render :edit
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin_user_cannot_destroy
      render :index
      
    else
      @user.destroy
      flash[:notice] = "ユーザを削除しました"
      redirect_to admin_users_path
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
