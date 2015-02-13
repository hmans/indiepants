class Pants::AuthController < ApplicationController
  def login
    @user = current_site

    if request.post? && @user.authenticate(params[:user][:password])
      login_user @user
      redirect_to :root
    end
  end

  def logout
    logout_user
    redirect_to :root
  end
end
