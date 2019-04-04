class SessionsController < ApplicationController
  def new
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  def create
    # 1. Find the user
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    # 2. Did we find the user in db?
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["INVALID CREDENTIALS"]
      render :new
    end
  end

end