class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :login_required

  def logout_required
    if current_user
      flash[:alert] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end
  

  def current_user?(user)
    user == current_user
  end

  
  private

  def login_required
    unless current_user
      flash[:alert] = "ログインしてください"
      redirect_to new_session_path
    end
  end

end
