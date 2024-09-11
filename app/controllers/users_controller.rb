class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  before_action :logout_required, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "アカウントを登録しました"
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
    if @user.update(user_params)
      flash[:notice] = "アカウントを更新しました"
      redirect_to user_path(@user)
    end
  end




  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to tasks_path unless current_user?(@user)
  end

end
