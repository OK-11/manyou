class SessionsController < ApplicationController

  skip_before_action :login_required, only: [:new, :create]

  before_action :logout_required, only: [:new , :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user.present? && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      if @user.admin?
        redirect_to admin_users_path
      else
        redirect_to tasks_path
      end
    else
      flash.now[:alert] = "メールアドレスまたはパスワードに誤りがあります"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "ログアウトしました"
    redirect_to new_session_path
  end
end
