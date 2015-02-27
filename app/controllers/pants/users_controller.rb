class Pants::UsersController < ApplicationController
  respond_to :html, :json
  respond_to :css, only: [:show]

  before_action :ensure_logged_in!, except: [:show]
  before_action :load_user

  def show
    respond_with @user do |f|
      f.css do
        if @user.custom_css.present?
          render text: @user.custom_css, content_type: "text/css"
        else
          render text: "not found", status: 404
        end
      end
    end
  end

  def edit
    respond_with @user
  end

  def update
    @user.update_attributes(user_params)
    respond_with @user, location: :root
  end

  def export
    respond_with @user do |format|
      format.json do
        if params[:download] then
          filename = "#{@user.host.parameterize}-export-#{Time.now.to_formatted_s(:db).parameterize}.json"
          headers['Content-Disposition'] = "attachment; filename=#{filename}"
        end
      end
    end
  end

private

  def load_user
    @user = current_site
  end

  def user_params
    params.require(:pants_user).permit(:name, :custom_css)
  end
end
