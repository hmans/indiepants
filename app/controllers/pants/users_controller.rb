class Pants::UsersController < ApplicationController
  respond_to :html, :json
  respond_to :css, only: [:show]

  before_action :ensure_logged_in!, except: [:show]
  before_action :load_user

  def show
    respond_with @user do |f|
      f.css { render text: @user.custom_css, content_type: "text/css" }
    end
  end

  def edit
    respond_with @user
  end

  def update
    @user.update_attributes(user_params)
    respond_with @user, location: :root
  end

private

  def load_user
    @user = current_site
  end

  def user_params
    params.require(:pants_user).permit(:name, :custom_css)
  end
end
