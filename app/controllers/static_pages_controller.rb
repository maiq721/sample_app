class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.by_date.page(params[:page]).per Settings.show_limit.show_10
  end

  def help; end

  def about; end

  def contact; end
end
