class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.by_date.build micropost_params
    if @micropost.save
      flash[:success] = t ".success_create"
      redirect_to root_path
    else
      @feed_items = current_user.feed.by_date.page(params[:page]).per Settings.microposts_controller.item_num
      render root_path
    end
  end

  def destroy
    @micropost.destroy ? flash[:success] = t(".deleted") : flash[:danger] = t(".fail")
    redirect_to root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost
    redirect_to root_path
  end
end
