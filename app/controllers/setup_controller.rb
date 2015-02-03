class SetupController < ApplicationController
  # We can only run this controller if there is _no_ current site.
  #
  skip_before_filter :ensure_current_site

  before_filter do
    if current_site.present?
      redirect_to :root
    end
  end

  def setup
    @user = User.local.build

    if request.post?
      @user.attributes = user_params.merge(host: request.host)
      if @user.save
        login_user @user
        redirect_to :root
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end