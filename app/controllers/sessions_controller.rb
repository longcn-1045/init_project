class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == Settings.session.remember_me ? remember(@user) : forget(@user)
        flash[:danger] = t ".login_success"
        redirect_back_or @user
      else
        flash[:warning] = t ".account_not_activated"
        redirect_to root_url
      end
    else
      flash[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?

    flash[:success] = t ".logout"
    redirect_to root_url
  end
end
