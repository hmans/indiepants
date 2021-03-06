module Pants
  class SetupController < ApplicationController
    # We can only run this controller if there is _no_ current site.
    #
    skip_before_filter :ensure_current_site

    before_action do
      if current_site.present?
        redirect_to :root
      end
    end

    before_action :ensure_host_is_claimable
    before_action :ensure_logged_out!

    def setup
      @user = User.local.build

      if request.post?
        @user.attributes = user_params.merge(url: request.url)
        if @user.save
          login_user @user
          redirect_to :root
        end
      end
    end

    private

    def user_params
      params.require(:pants_user).permit(:name, :password)
    end

    def ensure_host_is_claimable
      unless request.host =~ Rails.application.config.x.claimable_hosts
        # TODO: make this nicer. :)
        render text: "This host can't be claimed."
        return
      end
    end
  end
end
