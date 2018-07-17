class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == Settings.session_controller.session ? 
        remember(user) : forget(user)
        redirect_to user
      else
        flash[:warning] = t ".check_mail"
        redirect_to root_path
      end
    else
      flash[:danger] = t ".danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
