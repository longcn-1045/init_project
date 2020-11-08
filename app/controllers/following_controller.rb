class FollowingController < ApplicationController
  before_action :find_user

  def index
    @title = t ".title"
    @users = @user.following.page(params[:page]).per Settings.user.per_page
    render "users/show_follow"
  end
end
