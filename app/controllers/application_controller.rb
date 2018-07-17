class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end
  
  def logged_in_user
    return if logged_in?
    flash[:danger] = t :log_in
    redirect_to login_url
  end 

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t :user_not_exit
    redirect_to root_url
  end
end
