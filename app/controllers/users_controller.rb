class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page]).per Settings.user_controller.per_paginate
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.user_controller.show_5
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user&.update_attributes user_params
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t :delete
    else
      flash[:danger] = t :cannot_del
    end
    redirect_to users_path
  end

  def following
    @title = t ".title_following"
    @user  = User.find_by id: params[:id]
    if @user
      @users = @user.following.page(params[:page]).per Settings.user_controller.following.show_follow
      render :show_follow
    else
      flash[:warning] =  t ".not_follow"
    end
  end

  def followers
    @title = t ".title_follower"
    @user  = User.find_by id: params[:id]
    if @user
      @users = @user.followers.page(params[:page]).per Settings.user_controller.following.show_follow
      render :show_follow
    else
      flash[:warning] = t ".dont_follow"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
